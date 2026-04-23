require 'sqlite3'
require 'bcrypt'
class Seeder

  def self.seed!
    drop_tables
    create_tables
    populate_tables
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS places')
    db.execute('DROP TABLE IF EXISTS categories')
    db.execute('DROP TABLE IF EXISTS places_categories')
    db.execute('DROP TABLE IF EXISTS users')
  end

  def self.create_tables
    db.execute('CREATE TABLE places (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                rating INTEGER, 
                review TEXT)')
    
    db.execute('CREATE TABLE categories (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL)')

    db.execute('CREATE TABLE places_categories (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                places_id INTEGER NOT NULL,
                categories_id INTEGER NOT NULL)')
    
    db.execute('CREATE TABLE users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL,
                password TEXT NOT NULL)')
  
  end

  def self.populate_tables

    password_hashed = BCrypt::Password.create("1234")
    p "Storing hashed password (#{password_hashed}) to DB. Clear text password (1234) never saved."
    db.execute('INSERT INTO users (username, password) VALUES (?, ?)', ["lovisa", password_hashed])
   
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Skansen Kronan", 7, "Fin utsikt över Haga, Vasa och Linné!")')
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Änggårdsbergen", 5, "En fin promenad, särskilt på sommaren.")')
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Karlatornet", 3, "Fin utsikt men man kommer bara till våning 58")')
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Trädgårdsföreningen", 6, "Riktigt härligt ställe mitt i stan")')
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Botaniska trädgården", 10, "JÄTTEFINT PÅ VÅREN OCH SOMMAREN")')
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Lisebergshjulet", 5, "Fin utsikt men man måste betala för inträde och åkpass eller biljett")')
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Gothia Towers", 4, "Högt upp, fin utsikt, dyra räkmackor")')
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Delsjön", 5, "Bra vandringsled runt, fint att åka kanot på")')
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Marsstrand", 6, "Fin natur")')


    db.execute('INSERT INTO categories (name) VALUES ("Utsikt")')
    db.execute('INSERT INTO categories (name) VALUES ("Berg")')
    db.execute('INSERT INTO categories (name) VALUES ("Skog")')
    db.execute('INSERT INTO categories (name) VALUES ("Hav")')
    db.execute('INSERT INTO categories (name) VALUES ("Sjö")')
    db.execute('INSERT INTO categories (name) VALUES ("Byggnader")')
    db.execute('INSERT INTO categories (name) VALUES ("Växter och Odling")')

    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (1, 6)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (1, 2)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (2, 2)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (2, 3)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (3, 6)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (3, 1)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (4, 7)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (5, 7)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (5, 3)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (6, 1)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (7, 6)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (7, 1)')    
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (8, 5)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (8, 3)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (9, 4)')

  end


  def self.db
    return @db if @db
    @db = SQLite3::Database.new('db/places.sqlite')
    @db.results_as_hash = true
    @db
  end

end