require 'json'

class Flash

  def initialize(req)
    @flash = {
      prev: JSON.parse(req.cookies['_ribs_app_flash'] || '{}'),
      next: {},
      now: {}
    }
  end

  def [](key)
    key = key.to_sym
    @flash[:next][key] || @flash[:prev][key] || @flash[:now][key]
  end

  def []=(key, value)
    key = key.to_sym
    @flash[:next][key] = value
  end

  def to_cookie
    { path: '/', value: @flash[:next].to_json }
  end

  def now
    @flash[:now]
  end

end
