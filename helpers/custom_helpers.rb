module CustomHelpers
  def tag_list(tags)
    links = tags.map do |tag|
      link_to(tag, tag_path(tag))
    end

    links.join(", ").html_safe
  end
end
