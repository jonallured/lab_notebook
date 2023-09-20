group "middleman" do
  guard "middleman" do
    files = %w[config.rb]
    watch(/^(#{files.join("|")})$/)

    directories = %w[article_templates data helpers lib source]
    watch(%r{^(#{directories.join("|")})/.*$})
  end
end

group "watch_notes" do
  guard "shell" do
    ignore(%r{^source/notes/\.git})

    watch(%r{^source/notes/.*$}) do
      message = "Auto-adding this diff from Guard"
      command = "cd source/notes && git add . && git commit -m '#{message}'"
      system command
    end
  end
end
