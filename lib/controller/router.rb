class Route

  def self.regex(str)
    return Regexp.new('/') if str == '/'

    Regexp.new(str.split('/').map { |s| self.wildcard(s) || s }.join('/'))
  end

  def self.wildcard(str)
    "(?<#{str[1..-1]}>\w+)" if str[0] == ":"
  end

  attr_reader :pattern, :http_verb, :controller, :action

  def initialize(pattern, http_verb, controller, action)
    @pattern = Route.regex(pattern)
    @http_verb = http_verb.downcase.to_sym
    @controller = controller
    @action = action
  end

  def matches?(req)
    http_verb == req.request_method.downcase.to_sym && pattern =~ req.path
  end

  def named_captures(matchdata)
    matchdata.names.zip(matchdata.captures).to_h
  end

  def run(req, resp)
    route_params = named_captures(pattern.match(req.path))
    controller.new(req, resp, route_params).invoke_action(action)
  end
end

class Router

  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, http_verb, controller, action)
    @routes << Route.new(pattern, http_verb, controller, action)
  end

  [:get, :post, :put, :delete].each do |http_verb|
    define_method(http_verb) do |pattern, controller, action|
      add_route(pattern, http_verb, controller, action)
    end
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  def match(req)
    routes.find { |route| route.matches?(req) }
  end

  def run(req, resp)
    if route = match(req)
      route.run(req, resp)
    else
      resp.status = 404
      resp.write('Page not found')
    end
  end
end
