require 'will_paginate/array'

module Refinery
  module Admin
    module Blog
      class PostsController < ::Admin::BaseController


        crudify :'refinery/blog_post',
                :title_attribute => :title,
                :order => 'published_at DESC'

        def uncategorized
          @blog_posts = Refinery::BlogPost.uncategorized.paginate(:page => params[:page], 
                                                                  :per_page => Refinery::BlogPost.per_page)
        end

        def tags
          op =  case ActiveRecord::Base.connection.adapter_name.downcase
                when 'postgresql'
                  '~*'
                else
                  'LIKE'
                end
          wildcard =  case ActiveRecord::Base.connection.adapter_name.downcase
                      when 'postgresql'
                        '.*'
                      else
                        '%'
                      end
          @tags = Refinery::BlogPost.tag_counts_on(:tags).where(
              ["tags.name #{op} ?", "#{wildcard}#{params[:term].to_s.downcase}#{wildcard}"]
            ).map { |tag| {:id => tag.id, :value => tag.name}}
          render :json => @tags.flatten
        end

        def create
          # if the position field exists, set this object as last object, given the conditions of this class.
          if Refinery::BlogPost.column_names.include?("position")
            params[:blog_post].merge!({
              :position => ((Refinery::BlogPost.maximum(:position, :conditions => "")||-1) + 1)
            })
          end

          if Refinery::BlogPost.column_names.include?("user_id")
            params[:blog_post].merge!({
              :user_id => current_user.id
            })
          end

          if (@blog_post = Refinery::BlogPost.create(params[:blog_post])).valid?
            (request.xhr? ? flash.now : flash).notice = t(
              'refinery.crudify.created',
              :what => "'#{@blog_post.title}'"
            )

            unless from_dialog?
              unless params[:continue_editing] =~ /true|on|1/
                redirect_back_or_default(main_app.refinery_admin_blog_posts_path)
              else
                unless request.xhr?
                  redirect_to :back
                else
                  render :partial => "/shared/message"
                end
              end
            else
              render :text => "<script>parent.window.location = '#{admin_blog_posts_url}';</script>"
            end
          else
            unless request.xhr?
              render :action => 'new'
            else
              render :partial => "/shared/admin/error_messages",
                     :locals => {
                       :object => @blog_post,
                       :include_object_name => true
                     }
            end
          end
        end

        before_filter :find_all_categories,
                      :only => [:new, :edit, :create, :update]

        before_filter :check_category_ids, :only => :update

      protected
        def find_all_categories
          @blog_categories = Refinery::BlogCategory.find(:all)
        end

        def check_category_ids
          params[:blog_post][:category_ids] ||= []
        end
      end
    end
  end
end
