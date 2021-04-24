Time.zone = 'US/Central'

set :layout, 'default'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true

set :build_dir, 'static/public'

page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

activate :blog do |blog|
  blog.default_extension = '.md'
  blog.layout = 'general_notes'
  blog.new_article_template = File.expand_path('article_templates/default.erb', File.dirname(__FILE__))
  blog.permalink = '{id}.html'
  blog.prefix = 'notes'
  blog.sources = 'general/{year}/{month}/{title}.html'
  blog.tag_template = 'tag.html'
end

activate :directory_indexes
set :trailing_slash, false

activate :livereload

activate :syntax, line_numbers: true

paths = Dir.glob('source/notes/one-on-ones/*-*')
template_path = 'notes/one-on-ones/template.html'
ignore template_path
paths.each do |path|
  slug = path.split('/').last
  locals = { slug: slug }
  target_path = "notes/one-on-ones/#{slug}/index.html"
  proxy target_path, template_path, locals: locals
end
