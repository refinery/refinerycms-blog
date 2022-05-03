shared_examples 'creating a category' do
  let(:creating_a_category) {
    -> (title, locale=:en){
          Mobility.locale = locale
          visit refinery.blog_admin_posts_path
          click_link "Create new category"
          fill_in "Title", with: title
          click_button "Save"
        }
      }
  end

