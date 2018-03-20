require_relative 'db_connection'
require_relative 'inflector'
require_relative 'searchable'
require_relative 'associatable'


class SQLObject

  extend Searchable
  extend Associatable

  # class methods

  def self.columns
    SQL = """
      SELECT 
        *
      FROM 
        #{self.table_name}
      LIMIT 
        1
    """

    @columns ||= DB.execute2(SQL).first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |col|
      define_method(col) { attributes[col] }
      define_method("#{col}=") do |val|
        attributes[col] = val
      end
    end
  end

  def self.table_name
    @table_name || @table_name = Inflect.table(self.to_s)
  end

  def self.parse(results)
    results.map { |params| self.new([params]) }
  end

  def self.find(id)
    SQL = """
      SELECT 
        *
      FROM 
        #{self.table_name}
      WHERE
        id = ?
    """
    results = DB.execute(SQL, id)
    self.new(results.first) unless results.empty?
  end

  # instance methods 

  def columns
    self.class.columns
  end

  def table_name
    self.class.table_name
  end

  def initialize(params = {})
    params.each do |key, val|
      raise "unknown attribute '#{key}'" unless columns.include?(key.to_sym)
      send("#{key}=".to_sym, val)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    columns.map { |attrb| send(attrb) }
  end

  def insert
    SQL = """
      INSERT INTO
        #{table_name} #{columns.join(', ')}
      VALUES
        (#{columns.map { '?' }.join(', ')})
    """
    DB.execute(SQL, *attribute_values)
    self.id = DB.last_insert_row_id
  end

  def update
    set_line = columns.map { |col| "#{col} = ?" }.join(', ')
    SQL = """
      UPDATE 
        #{table_name}
      SET 
        #{set_line}
      WHERE
        id = ?
    """
    DB.execute(SQL, *attribute_values, self.id)
  end

  def save
    self.id ? update : insert
  end

end