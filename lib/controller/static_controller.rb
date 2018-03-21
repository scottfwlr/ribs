require_relative 'base'

class StaticController < Controller

  def serve
    content = readfile(req.path)
    mimetype = case filetype = req.path[/\.(.+)$/, 1]
    when "png", "jpg", "gif"
      "image/#{filetype}"
    when "json", "zip", "pdf"
      "application/#{filetype}"
    when "csv", "html", "css"
      "text/#{filetype}"
    else
      "text/plain"
    end
    render_content(content, mimetype)
  rescue Errno::ENOENT
    resp.status = 404
    resp.finish
  end

  private

  def readfile(fname)
    File.read(fname) if fname =~ /^\/?public\//
  end
end
