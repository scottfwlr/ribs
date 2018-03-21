require_relative 'middleware'

class Static < Middleware

  def call(env)
    req = Rack::Request.new(env)
    resp = Rack::Response.new
    StaticController.new(req, resp).serve
  end

end
