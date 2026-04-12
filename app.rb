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

    get '/places/new' do
      @categories = db.execute('SELECT name FROM categories')
      erb(:"places/new")
    end

    get '/places' do
      @places = db.execute('SELECT * FROM places ORDER BY name')
      @categories = db.execute('SELECT name FROM categories')
      p @places
      erb(:"places/index")
    end

    get '/places/:id' do | id |
      @place = db.execute('SELECT * FROM places WHERE id = ' +id).first
      @categories = db.execute('SELECT name FROM categories')
      erb(:"places/show")
    end
    
    get '/places/:id/edit' do | id |
      @places = db.execute('SELECT * FROM places WHERE id = ?', id).first
      @categories = db.execute('SELECT name FROM categories')
      erb(:"places/edit")
    end

    post '/places/:id/delete' do | id |
      @place = db.execute('DELETE FROM places WHERE id = ' +id)
      redirect('/places')
    end

    post '/places' do
      name = params["place_name"]
      rating = params["place_rating"]
      review = params["place_review"]
      db.execute('INSERT INTO places (name, rating, review) VALUES (?, ?, ?)', [name, rating, review])
      
      redirect('/places')
    end

    post '/places/:id/update' do | id |
      params
      updateParams = [
        params['place_name'], 
        params['place_rating'], 
        params['place_review'], 
        id]

      db.execute('UPDATE places SET name = ?, rating = ?, review = ? WHERE id = ?', updateParams)

      redirect('/places')
    end

    get '/categories' do
      @categories = db.execute('SELECT * FROM categories ORDER BY id')
      p @categories
      erb(:"categories/index")
    end

    get '/categories/:id' do | id |
      @category = db.execute('SELECT * FROM places WHERE id = ' +id).first
      @categories = db.execute('SELECT name FROM categories')
      erb(:"categories/show")
    end
    

  
    

end
