class Resolver
  def initialize(mapping)
    @mapping = mapping
  end

  def resolve(modifications, additions, removals)
    for modified in modifications
      if modified.match /Dropbox/
        # this event does fire, but i don't understand what i should do with
        # it, so i'm ignoring it for now
        puts 'dropbox modification'
        puts "  #{modified}"
      else
        puts 'local modification'
        puts "  #{modified}"

        stale_dropbox_path = @mapping[modified]
        File.delete stale_dropbox_path
        tmp_path = `bin/encrypt #{modified}`.chomp
        dropbox_path = File.join Dir.home, 'Dropbox/lab_notes/entries_test', File.basename(tmp_path)
        FileUtils.cp tmp_path, dropbox_path
        @mapping[modified] = dropbox_path
      end
    end

    for added in additions
      if added.match /Dropbox/
        puts 'dropbox added'
        puts "  #{added}"

        local_path = `bin/decrypt #{added}`.chomp
        @mapping[local_path] = added
      else
        puts 'local added'
        puts "  #{added}"

        tmp_path = `bin/encrypt #{added}`.chomp
        dropbox_path = File.join Dir.home, 'Dropbox/lab_notes/entries_test', File.basename(tmp_path)
        FileUtils.cp tmp_path, dropbox_path
        @mapping[added] = dropbox_path
      end
    end

    for removed in removals
      if removed.match /Dropbox/
        puts 'dropbox removed'
        puts "  #{removed}"

        local_path = @mapping.invert[removed]

        if local_path
          @mapping.delete(local_path)
          File.delete local_path
        end
      else
        puts 'local removed'
        puts "  #{removed}"

        dropbox_path = @mapping[removed]

        if dropbox_path
          @mapping.delete(removed)
          File.delete dropbox_path
        end
      end
    end
  end
end
