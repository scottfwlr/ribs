require 'erb'
require_relative '../guts/inflector'
require_relative 'session'
require_relative 'flash'

class AlreadyRenderedError < StandardError; end

class Controller

  def self.protect_from_forgery
    @protecting = true
  end

  def self.protect_from_forgery?
    @protecting
  end


  attr_reader :req, :resp, :params

  def initialize(req, resp, route_params = {})
    @req = req
    @resp = resp
    @params = req.params.merge(route_params)
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def invoke_action(name)
    check_csrf if should_check_csrf
    self.send(name)
    render(name.to_s) unless already_built_response?
  end

  def redirect_to(url)
    you_only_render_once
    resp['Location'] = url
    resp.status = 302
    cookie_housekeeping
  end

  def render_content(content, content_type)
    you_only_render_once
    resp['Content-Type'] = content_type
    resp.write(content)
    cookie_housekeeping
  end

  def render(template)
    template = File.read("views/#{Inflect.declassify(self.class.to_s)}/#{template}.html.erb")
    content = ERB.new(template).result(binding)
    render_content(content, 'text/html')
  end

  def form_csrf_token
    csrf
  end

  private

  def csrf
    unless @csrf 
      @csrf = SecureRandom.urlsafe_base64
      resp.set_cookie('csrf', value: @csrf)
    end
    @csrf
  end

  def check_csrf
    cookie_token = req.cookies['csrf']
    param_token = params['csrf']
    raise 'Invalid authenticity token' unless cookie_token && param_token && cookie_token == param_token
  end

  def should_check_csrf
    self.class.protect_from_forgery? && req.request_method != 'GET' 
  end

  def already_built_response?
    if @already_built_response
      true
    else
      @already_built_response = true
      false
    end
  end

  def you_only_render_once
    raise AlreadyRenderedError if already_built_response?
  end

  def cookie_housekeeping
    resp.set_cookie('_ribs_app', session.to_cookie)
    resp.set_cookie('_ribs_app_flash', flash.to_cookie)
  end

end
