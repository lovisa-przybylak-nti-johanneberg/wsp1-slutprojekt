require 'sqlite3'

class Seeder

  def self.seed!
    drop_tables
    create_tables
    populate_tables
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS places')
  end

  def self.create_tables
    db.execute('CREATE TABLE places (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                rating INTEGER, 
                review TEXT)')
  end

  def self.populate_tables
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Skansen Kronan", 7, "Fin utsikt över Haga, Vasa och Linné!")')
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Änggårdsbergen", 5, "En fin promenad, särskilt på sommaren.")')
    db.execute('INSERT INTO places (name, rating, review) VALUES ("Karlatornet", 3, "Fin utsikt men man kommer bara till våning 58")')
  end

  private
  def self.db
    return @db if @db
    @db = SQLite3::Database.new('db/places.sqlite')
    @db.results_as_hash = true
    @db
  end

end
