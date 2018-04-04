# Load up Ribs

require_relative 'lib/ribs'

# Load up our models

require_relative 'models/paper'
require_relative 'models/scientist'
require_relative 'models/institute'

# Load our controllers

require_relative 'controllers/root_controller'

require_relative 'controllers/papers_controller'
require_relative 'controllers/scientists_controller'
require_relative 'controllers/institutes_controller'

# Define our routes

router = Router.new
router.draw do
  get '/papers/:id', PapersController, :show
  get '/papers', PapersController, :index

  get '/scientists/:id', ScientistsController, :show
  get '/scientists', ScientistsController, :index

  get '/institutes/:id', InstitutesController, :show
  get '/institutes', InstitutesController, :index

  get '/', RootController, :root
end

# Fire up the server

app = Proc.new do |env|
  req = Rack::Request.new(env)
  resp = Rack::Response.new
  router.run(req, resp)
  resp.finish
end

app = Rack::Builder.new do
  # use ShowExceptions
  map "/public" do
    use Static
  end
  run app
end.to_app

Rack::Server.start(app: app, Port: ARGV.first.to_i) 
