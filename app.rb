require 'debug'
require "awesome_print"

class App < Sinatra::Base

    setup_development_features(self)

    # Funktion för att prata med databasen
    # Exempel på användning: db.execute('SELECT * FROM fruits')
    def db
      return @db if @db
      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end

    # Routen /
    get '/' do
      redirect ('/places')
    end

    get '/places' do
      @places = db.execute('SELECT * FROM places ORDER BY name')
      p @places
      erb(:"places/index")
    end

    get '/places/:id' do | id |
      @place = db.execute('SELECT * FROM places WHERE id = ' +id).first
      erb(:"places/show")
    end
    
    #get '/places/new' do
     # erb(:"places/new")
    #end

    post '/places/:id/delete' do | id |
      @place = db.execute('DELETE FROM places WHERE id = ' +id)
      redirect('/places')
    end

    #post '/places' do
     # name = params["place_name"]
     # rating = params["place_rating"]
     # review = params["place_review"]
     # db.execute('INSERT INTO places (name, rating, review) VALUES (?, ?, ?), [name, rating, review]')
     # redirect('/places')
    #end

    
    

end
