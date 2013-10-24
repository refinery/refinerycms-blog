module Refinery
  module Blog
    module Admin
      class PostsController < ::Refinery::AdminController

        crudify :'refinery/blog/post',
                :order => 'published_at DESC',
                :include => [:translations, :author]

        before_filter :find_all_categories,
                      :only => [:new, :edit, :create, :update]

        before_filter :check_category_ids, :only => :update

        def uncategorized
          @posts = Refinery::Blog::Post.uncategorized.page(params[:page])
        end

        def tags
          if ActiveRecord::Base.connection.adapter_name.downcase == 'postgresql'
            op = '~*'
            wildcard = '.*'
          else
            op = 'LIKE'
            wildcard = '%'
          end

          @tags = Refinery::Blog::Post.tag_counts_on(:tags).where(
              ["tags.name #{op} ?", "#{wildcard}#{params[:term].to_s.downcase}#{wildcard}"]
            ).map { |tag| {:id => tag.id, :value => tag.name}}
          render :json => @tags.flatten
        end

        def new
          @post = ::Refinery::Blog::Post.new(:author => current_refinery_user)
        end

        def create
          # if the position field exists, set this object as last object, given the conditions of this class.
          if Refinery::Blog::Post.column_names.include?("position")
            params[:post].merge!({
              :position => ((Refinery::Blog::Post.maximum(:position, :conditions => "")||-1) + 1)
            })
          end

          if (@post = Refinery::Blog::Post.create(params[:post])).valid?
            (request.xhr? ? flash.now : flash).notice = t(
              'refinery.crudify.created',
              :what => "'#{@post.title}'"
            )

            unless from_dialog?
              unless params[:continue_editing] =~ /true|on|1/
                redirect_back_or_default(refinery.blog_admin_posts_path)
              else
                unless request.xhr?
                  redirect_to :back
                else
                  render "/shared/message"
                end
              end
            else
              render :text => "<script>parent.window.location = '#{refinery.blog_admin_posts_url}';</script>"
            end
          else
            unless request.xhr?
              render :new
            else
              render :partial => "/refinery/admin/error_messages",
                     :locals => {
                       :object => @post,
                       :include_object_name => true
                     }
            end
          end
        end

        def delete_translation
          find_post
          @post.translations.find_by_locale(params[:locale_to_delete]).destroy
          flash[:notice] = ::I18n.t('delete_translation_success', :scope => 'refinery.blog.admin.posts.post')
          redirect_to refinery.blog_admin_posts_path
        end

      protected
        def find_post
          @post = Refinery::Blog::Post.find_by_slug_or_id(params[:id])
        end

        def find_all_categories
          @categories = Refinery::Blog::Category.all
        end

        def check_category_ids
          params[:post][:category_ids] ||= []
        end
      end
    end
  end
end
