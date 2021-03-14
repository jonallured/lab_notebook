def simple_target(sprint_slug, something)
  "source/notes/sprints/#{sprint_slug}#{something}.html.md"
end

def standup_target(sprint_slug, something)
  prefix_map = {
    'monday' => '1',
    'tuesday' => '2',
    'wednesday' => '3',
    'thursday' => '4',
    'friday' => '5'
  }

  _, week_number, day_of_week, = something.split('/')
  prefix = prefix_map[day_of_week]
  "source/notes/sprints/#{sprint_slug}/#{week_number}/#{prefix}-#{day_of_week}.html.md"
end

def translate(sprint_slug, file)
  something = file.split(sprint_slug).last.split('.').first
  if something.include?('standup')
    standup_target(sprint_slug, something)
  else
    simple_target(sprint_slug, something)
  end
end

paths = Dir.glob('../notes/sprints/*').sort.reverse

paths.each do |path|
  sprint_slug = path.split('/').last
  system "./bin/new_sprint #{sprint_slug}"

  files = Dir.glob("#{path}/**/*.md").sort
  files.each do |file|
    data = File.read(file)
    next if data == ''

    something = file.split(sprint_slug).last.split('.').first
    next if something.include?('log')

    target = translate(sprint_slug, file)

    if target.include?('week-4') && !Dir.exist?("source/notes/sprints/#{sprint_slug}/week-4'")
      system "cp -r 'sprint_templates/yyyy-ss/week-2' 'source/notes/sprints/#{sprint_slug}/week-3'"
      system "cp -r 'sprint_templates/yyyy-ss/week-2' 'source/notes/sprints/#{sprint_slug}/week-4'"
    end

    command = "cp #{file} #{target}"
    system command
  end
end
