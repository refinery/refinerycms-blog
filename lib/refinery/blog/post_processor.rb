# Processors must have a method #process that takes markup and returns html

# load our processors
Dir["#{File.expand_path('../post_processor', __FILE__)}/**/*.rb"].each do |f|
  require f
end

