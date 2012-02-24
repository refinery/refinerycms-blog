namespace :refinery do
  namespace :testing do
    task :setup_extension do
      task = "bundle exec rake -f #{Refinery::Testing::Railtie.target_engine_path.join('Rakefile')} "
      task << "app:railties:install:migrations FROM='refinery_settings'"
      system task
    end
  end
end
