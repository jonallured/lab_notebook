Time.zone = "US/Central"

set :layout, "default"

page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :blog do |blog|
  blog.default_extension = ".md"
  blog.layout = "default"
  blog.new_article_template = File.expand_path("article_templates/default.erb", File.dirname(__FILE__))
  blog.permalink = "{id}.html"
  blog.prefix = "notes"
  blog.sources = "general/{year}/{month}/{title}.html"
end

activate :directory_indexes
set :trailing_slash, false

activate :livereload
