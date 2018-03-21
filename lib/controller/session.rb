require 'json'

class Session

  def initialize(req)
    @session = JSON.parse(req.cookies['_ribs_app'] || '{}')
  end

  def [](key)
    key = key.to_sym
    @session[key]
  end

  def []=(key, val)
    key = key.to_sym
    @session[key] = val
  end

  def to_cookie
    { path: '/', value: @session.to_json }
  end
end
