require 'action_view/helpers/tag_helper'
require 'action_view/helpers/url_helper'

module Refinery
  module Admin
    class PostPresenter < Refinery::BasePresenter
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
      include Refinery::TagHelper
      include Refinery::TranslationHelper

      attr_accessor :post, :created_at, :context, :urls
      delegate :refinery, :params, :output_buffer, :output_buffer=, :t, to: :context
      delegate_missing_to :post

      I18N_SCOPE = 'refinery.blog.admin.posts.post'

      def initialize(post, context)
        @context = context
        @created_at = post.created_at
        @post = post
        @urls = {
          edit: refinery.edit_blog_admin_post_path(post),
          delete: refinery.blog_admin_post_path(post),
          preview: refinery.blog_post_path(post)
        }
      end

      class << self
        attr_accessor :context, :posts, :view, :pagination_class
        delegate :tag, :group_by_date, to: :context

        def collection(posts, context)
          @context = context
          @pagination_class = context.pagination_css_class
          @posts = posts.map { |post| self.new(post, context) }
          self
        end

        def to_html
          tag.ul post_index(@posts), class: index_classes
        end

        private

        def post_index(posts)
          posts.each_with_index.reduce(ActiveSupport::SafeBuffer.new) do |buffer, (post, index)|
            buffer << post.to_html(index.odd?)
          end
        end

        def index_classes
          ['clearfix', 'pagination_frame', 'posts_list', pagination_class]
        end

      end

      def to_html(stripe = true)
        stripe_class = stripe ? 'on-hover' : 'on'
        tag.li id: "post_#{post.id}", class: stripe_class do
          entry = tag.span class: :item do
            [index_entry, *translations].join.html_safe
          end
          entry << actions
        end
      end

      def index_entry
        link_to post_title, urls[:edit], class: [:edit, :title],
                tooltip: t('edit', scope: 'refinery.admin.posts')
      end

      def post_title
        title.presence || translations.detect { |t| t.title.present? }.title
      end

      def post_meta
        tag.span class: [:preview] do
          post_information
        end
      end

      def actions
        tag.span class: :actions do
          [edit_icon, info_icon, delete_icon, preview_icon].join(' ').html_safe
        end
      end

      # Actions
      def preview_icon
        action_icon :preview, urls[:preview], t('view_live_html', scope: 'refinery.admin.posts')
      end

      def edit_icon
        action_icon :edit, urls[:edit], t('edit', scope: 'refinery.admin.posts', title: post_title)
      end

      def delete_icon
        delete_options = {
          class: %w[cancel confirm-delete],
          data: { confirm: ::I18n.t('message', scope: 'refinery.admin.delete', title: post_title) }
        }
        action_icon :delete, urls[:delete], t('delete', scope: 'refinery.admin.posts'), delete_options
      end

      def info_icon
        action_icon :info, '', post_information
      end

      def post_information
        published = "Published: %s " % post.published_at.try(:strftime, '%b %d, %Y') || 'draft'
        author =   "Author: %s" % post.author&.username || ''
        [published, author].join(' ').html_safe
      end

      def translations
        if Refinery::I18n.frontend_locales.many?
          tag.span class: :locales do
            switch_locale(post, urls[:edit], :post_title).html_safe
          end
        end
      end

    end
  end
end





