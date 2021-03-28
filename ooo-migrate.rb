# mv all the ooo files to include html in their filename
# source_paths = Dir.glob('source/notes/one-on-ones/*-*/*.md')
# source_paths.each do |source_path|
#   target_path = source_path.gsub(/\.md/, '.html.md')
#   command = "mv #{source_path} #{target_path}"
#   puts command
#   system command
# end
# add an index file in each folder so that it will list all the other files
index_template = 'ooo_templates/index.html.haml'
source_folders = Dir.glob('source/notes/one-on-ones/*-*')
source_folders.each do |folder|
  index_file = "#{folder}/index.html.haml"
  cp index_template index_file
  # replace some name with the slug
end
# add a helper to spit back that list for the index files
