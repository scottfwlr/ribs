require_relative 'db_connection'
require_relative 'inflector'


class SQLObject

  DB.open('books.db')

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


end