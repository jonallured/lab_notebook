class Sprint
  def self.compute_for(paths)
    paths.map { |path| new(path) }.sort.reverse
  end

  def initialize(path)
    @path = path
  end

  def title
    @path.split("/").last
  end

  def url
    "/notes/sprints/#{title}"
  end

  def <=>(other)
    title <=> other.title
  end
end

module CustomHelpers
  def calculate_sprints
    sprint_paths = Dir.glob("source/notes/sprints/20*")
    Sprint.compute_for(sprint_paths)
  end
end
