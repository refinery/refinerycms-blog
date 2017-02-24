module Refinery
  module Blog
    module Admin
      class PostsController < ::Refinery::AdminController
        crudify :'refinery/blog/post',
                :order => 'published_at DESC',
                :include => [:translations, :author]

        before_filter :find_all_categories,
                      :find_all_topic_categories,
                      :find_all_readtime_categories,
                      :find_all_expertise_categories,
                      :find_all_score_categories,
                      # :add_score_category,
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
            post_params.merge!({
              :position => ((Refinery::Blog::Post.maximum(:position, :conditions => "")||-1) + 1)
            })
          end

          if (@post = Refinery::Blog::Post.create(post_params)).valid?
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

      private

        def post_params
          params.require(:post).permit(permitted_post_params)
        end

        def permitted_post_params
          [
            :title, :body, :custom_teaser, :tag_list,
            :draft, :published_at, :custom_url, :user_id, :browser_title,
            :meta_description, :source_url, :source_url_title, :category_ids => []
          ]
        end

      protected

        def find_post
          @post = Refinery::Blog::Post.friendly.find(params[:id])
        end

        def find_all_categories
          @categories = Refinery::Blog::Category.all
        end

        def find_all_topic_categories
          @topic_categories = Refinery::Blog::Category.where("cat_type = 'topic'")
        end

        def find_all_readtime_categories
          @readtime_categories = Refinery::Blog::Category.where("cat_type = 'read_time'")
        end

        def find_all_expertise_categories
          @expertise_categories = Refinery::Blog::Category.where("cat_type = 'expertise_level'")
        end

        def find_all_score_categories
          @score_categories = Refinery::Blog::Category.where("cat_type = 'health_score'")
        end

        # def add_score_category
        #   @post = Refinery::Blog::Post.friendly.find(params[:id])
        #   # @new_score = Category.create(cat_type: "read_time")
        #   # @post.categories << @new_score
        #   @new_health_cat = Category.find_or_create_by_cat_type_and_value('health_score', params[:category][:value])
        #   # unless Category.exists?(:cat_type => "read_time")
        #   #   Category.create(cat_type: "read_time")
        #   # end
        #   # @post.categories.value << value
        # end

        def check_category_ids
          params[:post][:category_ids] ||= []
        end
      end
    end
  end
end
