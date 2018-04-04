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
    @db = PG.connect(dbname: db_file_name, host: 'localhost')
    # @db.results_as_hash = true
    # @db.type_translation = true
    @db
  end

  def self.db
    self.open(ENV['DATABASE_URL'] || 'papers') if @db.nil?
    @db
  end

  def self.execute(*args)
    sql, rest_args = args
    sql = self.process_sql(sql)

    if rest_args
      if rest_args.is_a?(Array) 
        self.db.exec_params(sql, rest_args.flatten)
      else
        self.db.exec_params(sql, [rest_args])      
      end
    else
      self.db.exec_params(sql)
    end
  end

  def self.execute2(*args)
    self.db.exec_params(*args)
  end

  def self.last_insert_row_id
    self.db.last_insert_row_id
  end

  def self.process_sql(sql)
    dolla = 1
    while sql.include?('?')
      sql.sub!('?', "$#{dolla}")
      dolla += 1
    end
    sql
  end

end
