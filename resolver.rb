# mapping:
# {
#   'entries/2017/01/01/08:00:00.md' => '9j3q0j0q34oiqjfu8934fjo.json'
# }
class Resolver
  def initialize(mapping)

  end

  def resolve(modifications, additions, removals)
    for modified in modifications
      if modified.match /Dropbox/
        # idk - what would this mean??
        puts 'dropbox modification'
        puts "  #{modified}"
      else
        # use mapping to remove from Dropbox
        old_hash = @mapping[modified]
        File.delete old_hash
        # use bin/encrypt to save to Dropbox
        new_hash = ``
        puts 'local modification'
        puts "  #{modified}"
      end
    end

    for added in additions
      if added.match /Dropbox/
        # use bin/decrypt to save locally
        puts 'dropbox added'
        puts "  #{added}"
      else
        # use bin/encrypt to save to Dropbox
        puts 'local added'
        puts "  #{added}"
      end
    end

    for removed in removals
      if removed.match /Dropbox/
        # use mapping to remove locally
        puts 'dropbox removed'
        puts "  #{removed}"
      else
        # use mapping to remove from Dropbox
        puts 'local removed'
        puts "  #{removed}"
      end
    end
  end
end
