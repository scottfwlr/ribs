# Ribs

## [Live demo](http://ribs-live-example.herokuapp.com/)

This is a website built with Ribs, being served live from a Heroku server. When you navigate to a page, Ribs is fetching the appropriate data from a SQL database and rendering HTML to be sent back to you.

### Ribs is a Ruby framework for building web apps. 

Ribs follows the Model-View-Controller convention:
 - [*Models*](lib/guts/) represent and encapsulate the data in your database.
 - [*Views*](views/) are templates for constructing what the user sees in their browser.
 - [*Controllers*](lib/controller/) respond to user requests by fetching models and populating views.


Interfacing with the database relies on an external gem, as does parsing raw HTTP requests and responses. Everything else is all Ribs, as you can see from the [Gemfile](Gemfile):
```ruby
# Gemfile

# for comprehending the postgresql database
gem 'pg'

# for comprehending http requests/responses
gem 'rack'

# the server
gem 'puma'
```


## Future Directions

 - Expand functionality to include the C, R, and D of CRUD
 - Add command-line interface for templating new apps

More philosophical: 
 - Rails encourages writing your models, controllers, and views "horizontally", in separate folders. This is a logical distinction to make, but I would like to experiment with a more "vertical" arrangement, with Model, Controller, and View logic for a given entity written all in the one file. This would reduce confusion around local vs instance variables and make things more explicit than Rails' approach of magically-available instance variables.
 - Assuming a conventional React/Redux frontend, what shortcuts and optimisations can we add? Can Ribs template a Redux store for us?