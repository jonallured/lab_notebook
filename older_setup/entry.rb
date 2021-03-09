class Entry
  def initialize(filename, markdown)
    @filename = filename
    @markdown = markdown
  end

  def to_html
    "<article>#{article_html}</article>"
  end

  private

  def article_html
    [headline, tag_list, entry_html].compact.join
  end

  def headline
    "<h1>#{@filename}</h1>"
  end

  def entry_html
    @markdown.render entry_markdown
  end

  def entry_markdown
    has_frontmatter? ? body : raw_content
  end

  def has_frontmatter?
    split_content.count > 1
  end

  def raw_content
    @content ||= File.read @filename
  end

  def body
    split_content.last
  end

  def tag_list
    return nil unless has_frontmatter?
    "<p class='tags'>#{tag_links.join(' | ')}</p>"
  end

  def tag_links
    tags.map { |tag| "<a href='#{tag}'>#{tag}</a>" }
  end

  def tags
    frontmatter.split(': ').last.chomp.split(', ')
  end

  def frontmatter
    split_content.first
  end

  def split_content
    raw_content.split /^---$/
  end
end
