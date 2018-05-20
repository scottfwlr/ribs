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
  get '/papers/new', PapersController, :new
  post '/papers', PapersController, :create
  get '/papers/:id/edit', PapersController, :edit
  put '/papers/:id', PapersController, :update
  delete '/papers/:id', PapersController, :destroy

  get '/scientists/:id', ScientistsController, :show
  get '/scientists', ScientistsController, :index
  get '/scientists/new', ScientistsController, :new
  post '/scientists', ScientistsController, :create
  get '/scientists/:id/edit', ScientistsController, :edit
  put '/scientists/:id', ScientistsController, :update
  delete '/scientists/:id', ScientistsController, :destroy

  get '/institutes/:id', InstitutesController, :show
  get '/institutes', InstitutesController, :index
  get '/institutes/new', InstitutesController, :new
  post '/institutes', InstitutesController, :create
  get '/institutes/:id/edit', InstitutesController, :edit
  put '/institutes/:id', InstitutesController, :update
  delete '/institutes/:id', InstitutesController, :destroy

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
