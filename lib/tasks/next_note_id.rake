require "humanize"
require "time"
require "yaml"

class Humancase
  def self.for(number)
    `echo #{number.humanize} | titlecase`.strip
  end
end

class LabNote
  def self.from_path(path)
    lab_note = new(path)
    lab_note.read_from_disk
    lab_note
  end

  attr_reader :attrs, :yaml

  def initialize(path)
    @path = path
    @attrs = {}
  end

  def read_from_disk
    @data = File.read(@path)
    `rm #{@path}`
    @yaml = YAML.safe_load(@data)

    attrs = yaml.dup
    attrs["date"] = Time.parse(yaml["date"])
    attrs["id"] = yaml["id"].to_i
    attrs["tags"] = Array(yaml["tags"])
    @attrs = attrs
  end

  def write_to_disk
    puts "*" * 80
    puts @path
    return unless has_changed?

    content_path = "tmp/#{attrs["id"]}.md"
    File.write(content_path, content)
    command = "./bin/re_id '#{attrs["title"]}' '#{attrs["date"]}' '#{attrs["tags"].join(",")}' '#{attrs["id"]}'"
    puts command
    system command
    `rm #{content_path}`
  end

  def <=>(other)
    attrs["date"] <=> other.attrs["date"]
  end

  def custom_title?
    Humancase.for(yaml["id"]) != yaml["title"]
  end

  def has_changed?
    yaml["id"] != attrs["id"] ||
      yaml["date"] != attrs["date"].to_s ||
      yaml["title"] != attrs["title"]
  end

  def content
    @data.split("---\n")[2..].join("---\n")
  end
end

desc "Compute next note id"
task :next_note_id do
  note_paths = Dir.glob("source/notes/**/**/*.md")

  ids = note_paths.map do |path|
    data = File.read(path)
    yaml = YAML.safe_load(data)
    yaml["id"].to_i
  end

  max = ids.max || 0
  puts max + 1
end

desc "Re-number the ids of notes"
task :re_id do
  note_paths = Dir.glob("source/notes/**/**/*.md")
  lab_notes = note_paths.map { |path| LabNote.from_path(path) }

  grouped_notes = lab_notes.group_by do |lab_note|
    lab_note.attrs["date"]
  end

  grouped_notes.each do |timestamp, lab_notes|
    next unless lab_notes.size > 0

    lab_notes.each_with_index do |lab_note, index|
      next unless index > 0

      new_timestamp = timestamp + index
      lab_note.attrs["date"] = new_timestamp
    end
  end

  sorted_notes = lab_notes.sort

  sorted_notes.each_with_index do |lab_note, index|
    natural_id = index + 1
    next if natural_id == lab_note.attrs["id"]

    lab_note.attrs["id"] = natural_id
    lab_note.attrs["title"] = Humancase.for(natural_id) unless lab_note.custom_title?
  end

  sorted_notes.each(&:write_to_disk)
end
