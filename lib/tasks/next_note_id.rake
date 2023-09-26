require "yaml"

desc "Compute next note id"
task :next_note_id do
  note_paths = Dir.glob("source/notes/**/**/*.md")

  ids = note_paths.map do |path|
    data = File.read(path)
    yaml = YAML.safe_load(data, permitted_classes: [Time])
    yaml["id"].to_i
  end

  max = ids.max || 0
  puts max + 1
end
