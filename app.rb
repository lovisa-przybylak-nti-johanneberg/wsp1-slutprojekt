require 'debug'
require "awesome_print"
require 'bcrypt'
require 'securerandom'

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

    configure do
        enable :sessions
        set :session_secret, SecureRandom.hex(64)
    end

    before do
      @categories = db.execute('SELECT * FROM categories')

      if session[:user_id]
        @current_user = db.execute("SELECT * FROM users WHERE id = ?", session[:user_id]).first
        ap @current_user
      end

    end

    # Routen /
    get '/' do
      redirect ('/places')
    end


    get '/admin' do
      if session[:user_id]
        erb(:"admin/index")
      else
        ap "/admin : Åtkomst nekad."
        status 401
        redirect '/acces_denied'
      end
    end

    get '/acces_denied' do
      erb(:acces_denied)
    end

    get '/login' do
      erb(:login)
    end

    post '/login' do
      request_username = params[:username]
      request_plain_password = params[:password]

      user = db.execute("SELECT * FROM users WHERE username = ?", request_username).first

      unless user
        ap "/login : Ogiltigt användarnamn."
        status 401
        redirect '/acces_denied'
      end

      db_id = user["id"].to_i
      db_password_hashed = user["password"].to_s

      bcrypt_db_password = BCrypt::Password.new(db_password_hashed)

      if bcrypt_db_password == request_plain_password
        ap "/login : Inloggad -> omdirigerar till admin"
        session[:user_id] = db_id
        redirect '/admin'
      else
        ap "/login : Ogiltigt lösenord."
        status 401
        redirect '/acces_denied'
      end
    end

    post '/logout' do
      ap "Loggar ut"
      session.clear
      redirect '/'
    end

    get '/users/new' do
      erb(:"users/new")
    end


    get '/places/new' do
      erb(:"places/new")
    end

    get '/places' do
      @places = db.execute('SELECT * FROM places ORDER BY name') 
      @admin = false
      if session[:user_id]
        @admin = true
      end
      erb(:"places/index")
    end

    get '/places/:id' do | id |
      @place = db.execute('SELECT * FROM places WHERE id = ?', id).first

      erb(:"places/show")
    end
    
    get '/places/:id/edit' do | id |
      @places = db.execute('SELECT * FROM places WHERE id = ?', id).first 
      erb(:"places/edit")
    end

    post '/places/:id/delete' do | id |
      @place = db.execute('DELETE FROM places WHERE id = ?', id)
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
      @categories = db.execute('SELECT * FROM categories')
      erb(:"categories/index")
    end

    get '/categories/:id' do | id |
      @categories = db.execute('SELECT * FROM categories')
      @category = db.execute('SELECT * FROM categories WHERE id = ?', id).first
      @places = db.execute('SELECT places.id AS place_id, places.name AS place_name, places.rating, places.review, categories.name AS category_name FROM places INNER JOIN places_categories ON places.id = places_categories.places_id INNER JOIN categories ON places_categories.categories_id = categories.id WHERE categories.id = ?', id)
      erb(:"categories/show")
    end
    
    post '/categories' do
      name = params["category_name"]
      db.execute('INSERT INTO places (name) VALUES (?)', [name])
      
      redirect('/places')
    end
  
    

end
