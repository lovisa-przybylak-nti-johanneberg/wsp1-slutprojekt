require 'sqlite3'

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
  end

  def self.populate_tables
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Skansen Kronan", 7, "Fin utsikt över Haga, Vasa och Linné!")')
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Änggårdsbergen", 5, "En fin promenad, särskilt på sommaren.")')
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Karlatornet", 3, "Fin utsikt men man kommer bara till våning 58")')

    db.execute('INSERT INTO categories (name) VALUES ("Utsikt")')
    db.execute('INSERT INTO categories (name) VALUES ("Berg")')
    db.execute('INSERT INTO categories (name) VALUES ("Skog")')
    db.execute('INSERT INTO categories (name) VALUES ("Hav")')
    db.execute('INSERT INTO categories (name) VALUES ("Sjö")')
    db.execute('INSERT INTO categories (name) VALUES ("Byggnader")')

    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (1, 5)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (2, 2)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (2, 1)')
    db.execute('INSERT INTO places_categories (places_id, categories_id) VALUES (2, 5)')
    



  end

  private
  def self.db
    return @db if @db
    @db = SQLite3::Database.new('db/places.sqlite')
    @db.results_as_hash = true
    @db
  end

end
