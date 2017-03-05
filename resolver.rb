class Resolver
  def initialize(mapping)
    @mapping = mapping
  end

  def resolve(modifications, additions, removals)
    for modified in modifications
      if modified.match /Dropbox/
        # idk - what would this mean??
        puts 'dropbox modification'
        puts "  #{modified}"
      else
        puts 'local modification'
        puts "  #{modified}"



        old_hash = @mapping[modified]
        File.delete old_hash
        tmp_path = `bin/encrypt #{modified}`.chomp
        dropbox_path = File.join Dir.home, 'Dropbox/lab_notes/entries_test', File.basename(tmp_path)
        FileUtils.cp tmp_path, dropbox_path
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
