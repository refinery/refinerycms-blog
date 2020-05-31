# encoding: utf-8
Refinery::Images.configure do |config|

  #  Refinery::Images configuration

  # Configures the maximum allowed upload size (in bytes) for an image
  # config.max_image_size = 5242880

  # Configure how many images per page should be displayed when a dialog is presented that contains images
  # config.pages_per_dialog = 18

  # Configure how many images per page should be displayed when a dialog is presented that
  # contains images and image resize options
  # config.pages_per_dialog_that_have_size_options = 12

  # Configure how many images per page should be displayed in the list of images in the admin area
  # config.pages_per_admin_index = 20

  # Configure image sizes
  # config.user_image_sizes = {:small=>"110x110>", :medium=>"225x255>", :large=>"450x450>"}

  # Configure image ratios
  # config.user_image_ratios = {:"16/9"=>"1.778", :"4/3"=>"1.333", :"1:1"=>1}

  # Configure allowed mime types for validation
  # config.allowed_mime_types = ["image/jpeg", "image/png", "image/gif", "image/tiff"]

  # Configure image view options
  # config.image_views = [:grid, :list]

  # Configure default image view
  # config.preferred_image_view = :grid

  # Configure Dragonfly.
  # Refer to config/initializers/refinery/dragonfly.rb for the full list of dragonfly configurations which can be used.
  # This includes all dragonfly config for Dragonfly v 1.1.1

  config.dragonfly_name = :refinery_images
  # config.dragonfly_verify_urls = true
  # config.dragonfly_secret = "991f02ff18ed4c9632010934b36e4f9c61dbccaaac5111f7"
  # config.dragonfly_url_host = ""
  # config.dragonfly_datastore_root_path = "/private/var/www/refinerycms-blog/spec/dummy/public/system/refinery/images"
  # config.dragonfly_url_format = "/system/refinery/images/:job/:basename.:ext"


  # Configure Dragonfly custom datastore
  # The custom_datastore setting by default defers to the Refinery::Images setting for this but can be set just for images.
  # config.dragonfly_custom_datastore_class = nil
  # config.dragonfly_custom_datastore_opts = {}

  # Configure S3 (you can also use ENV for this)
  # The s3_datastore setting by default defers to the Refinery::Dragonfly setting for this but can be set just for images.
  # config.s3_datastore = Refinery::Dragonfly.s3_datastore
  # config.s3_bucket_name = ENV['S3_BUCKET']
  # config.s3_access_key_id = ENV['S3_KEY']
  # config.s3_secret_access_key = ENV['S3_SECRET']
  # config.s3_region = ENV['S3_REGION']
  #
  #  further S3 configuration options
  # config.s3_fog_storage_options = nil
  # config.s3_root_path = nil
  # config.s3_storage_path = nil
  # config.s3_storage_headers = nil
  # config.s3_url_host = nil
  # config.s3_url_scheme = nil
  # config.s3_use_iam_profile = nil

end
