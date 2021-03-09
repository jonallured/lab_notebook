require 'fileutils'

class Resolver
  attr_reader :dropbox_folder, :local_folder

  def initialize(entry_folders)
    @dropbox_folder, @local_folder = entry_folders
    @mapping = Hash.new
  end

  def startup
    local_entry_paths = Dir["#{local_folder}/**/*.md"]
    dropbox_entry_paths = Dir["#{dropbox_folder}/*.json"]

    for dropbox_entry_path in dropbox_entry_paths
      print ?.
      local_path = `bin/decrypt #{dropbox_entry_path}`.chomp
      @mapping[local_path] = dropbox_entry_path
    end

    puts "\ndone decrypting"

    for local_entry_path in local_entry_paths
      tmp_path = `bin/encrypt #{local_entry_path}`.chomp
      dropbox_path = File.join dropbox_folder, File.basename(tmp_path)

      if File.exists? dropbox_path
        print ?.
      else
        FileUtils.cp tmp_path, dropbox_path
        print ?!
      end
      @mapping[local_entry_path] = dropbox_path
    end

    puts "\ndone encrypting"
  end

  def resolve(modifications, additions, removals)
    for modified in modifications
      if modified.match /Dropbox/
        # i don't understand this case, so i'm just logging it
        puts 'dropbox modification'
        puts "  #{modified}"
      else
        puts 'local modification'
        puts "  #{modified}"

        stale_dropbox_path = @mapping[modified]
        File.delete stale_dropbox_path
        tmp_path = `bin/encrypt #{modified}`.chomp
        dropbox_path = File.join dropbox_folder, File.basename(tmp_path)
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
        dropbox_path = File.join dropbox_folder, File.basename(tmp_path)
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
