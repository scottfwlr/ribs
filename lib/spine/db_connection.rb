require 'sqlite3'

class DB

  ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')
  BOOKS = 'books.db'

  # overwrite 'new' to make this a singleton
  def new
    self
  end

  def self.open(db_file_name)
    @db = SQLite3::Database.new(db_file_name)
    @db.results_as_hash = true
    @db.type_translation = true
    @db
  end

  def self.db
    self.open(BOOKS) if @db.nil?
    @db
  end

  def self.execute(*args)
    self.db.execute(*args)
  end

  def self.execute2(*args)
    self.db.execute2(*args)
  end

  def self.last_insert_row_id
    self.db.last_insert_row_id
  end

end
