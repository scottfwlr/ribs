require 'sqlite3'

# https://tomafro.net/2010/01/tip-relative-paths-with-file-expand-path
ROOT_FOLDER = File.join(File.dirname(__FILE__), '..')

class DB

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

  def self.execute(*args)
    @db.execute(*args)
  end

  def self.execute2(*args)
    @db.execute2(*args)
  end

  def self.last_insert_row_id
    @db.last_insert_row_id
  end

end
