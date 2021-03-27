class StaticApp
  attr_reader :root

  def initialize
    @root = __dir__
  end

  def call(env)
    data = compute_index_data(env)

    if data
      send_index_data(data)
    else
      fallback_app.call(env)
    end
  end

  private

  def compute_index_data(env)
    path_info = env['PATH_INFO']
    path = Rack::Utils.unescape(path_info)
    index_file = "#{root}/public#{path}/index.html"

    File.exist?(index_file) && File.read(index_file)
  end

  def send_index_data(data)
    [200, { 'Content-Type' => 'text/html' }, [data]]
  end

  def fallback_app
    @fallback_app ||= generate_fallback_app
  end

  def generate_fallback_app
    Rack::Directory.new(root)
  end
end

use Rack::Static, urls: [''], root: 'public', index: 'index.html', cascade: true

run StaticApp.new
