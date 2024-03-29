Time.zone = "US/Central"

set :layout, "default"

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true

set :build_dir, "static/public"

page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :blog do |blog|
  blog.default_extension = ".md"
  blog.layout = "note"
  blog.new_article_template = File.expand_path("templates/default.erb", File.dirname(__FILE__))
  blog.permalink = "notes/{id}.html"
  blog.sources = "notes/{year}/{month}/{title}.html"
  blog.tag_template = "tag.html"
end

activate :directory_indexes
set :trailing_slash, false

activate :livereload

activate :syntax, line_numbers: true
