Time.zone = "US/Central"

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false

activate :blog do |blog|
  blog.default_extension = ".md"
  blog.new_article_template = File.expand_path("article_templates/default.erb", File.dirname(__FILE__))
  blog.permalink = "{title}.html"
  blog.prefix = "notes"
  blog.sources = "{year}/{month}/{title}.html"
end
