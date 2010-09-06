class Blog::CategoriesController < BlogController

  def show
    @category = BlogCategory.find(params[:id])
  end
  
end