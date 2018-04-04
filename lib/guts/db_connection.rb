require 'pg'

class DB

  # ROOT_FOLDER = File.join(File.dirname(__FILE__), '../..')
  # PAPERS = File.join(ROOT_FOLDER, 'db/papers.db')

  # overwrite 'new' to make this a singleton
  def new
    self
  end

  def self.open(db_file_name)
    # @db = SQLite3::Database.new(db_file_name)
    @db = PG.connect(db_file_name)
    # @db.results_as_hash = true
    # @db.type_translation = true
    @db
  end

  def self.db
    self.open(ENV['DATABASE_URL']) if @db.nil?
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
