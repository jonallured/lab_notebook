class Sprint
  def self.compute_for(paths)
    paths.map { |path| new(path) }.sort.reverse
  end

  def initialize(path)
    @path = path
  end

  def title
    @path.split('/').last
  end

  def url
    "/notes/sprints/#{title}"
  end

  def <=>(other)
    title <=> other.title
  end
end

class Oneonone
  def self.compute_for(paths)
    paths.map { |path| new(path) }.sort
  end

  def initialize(path)
    @path = path
  end

  def title
    @path.split('/').last
  end

  def url
    "/notes/one-on-ones/#{title}"
  end

  def <=>(other)
    title <=> other.title
  end
end

class Something
  def self.compute_for(paths)
    paths.map { |path| new(path) }.sort
  end

  def initialize(path)
    @path = path
  end

  def title
    @path.split('/').last.split('.').first
  end

  def url
    slug = @path.split('/')[3]
    "/notes/one-on-ones/#{slug}/#{title}"
  end

  def <=>(other)
    title <=> other.title
  end
end

module CustomHelpers
  def calculate_sprints
    sprint_paths = Dir.glob('source/notes/sprints/20*')
    Sprint.compute_for(sprint_paths)
  end

  def calculate_one_on_ones
    paths = Dir.glob('source/notes/one-on-ones/*-*')
    Oneonone.compute_for(paths)
  end

  def calculate_individual_ooos(slug)
    paths = Dir.glob("source/notes/one-on-ones/#{slug}/*.html.md")
    Something.compute_for(paths)
  end
end
