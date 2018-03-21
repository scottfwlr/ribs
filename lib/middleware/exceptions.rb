require_relative 'middleware'

class ShowExceptions < Middleware

  def call(env)
    app.call(env)
  rescue StandardError => e
    ['500', {'Content-type' => 'text/html'}, [e.message, e.backtrace, excerpt_source(e)]]
  end

  private

  def excerpt_source(e)
    e.backtrace_locations.take(5).map do |btl|
      if bp = btl.absolute_path
        File.readlines(bp)[[0, btl.lineno-10].max .. btl.lineno+10].join("\n")
      end
    end.compact
  end

end
