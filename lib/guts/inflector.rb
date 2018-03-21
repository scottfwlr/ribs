class Inflect

  def self.new
    self
  end

  def self.table(string)
    self.plural(self.underscore(string))
  end

  def self.plural(string)
    string + "s"
  end

  def self.singular(string)
    string[/s$/] ? string[0..-2] : string
  end

  def self.camelcase(string)
    string.split('_').map(&:capitalize).join('')
  end

  def self.underscore(string)
    string.scan(/[A-Z][a-z]+/).map(&:downcase).join("_")
  end

  def self.declassify(string)
    self.underscore(string.split("::").last)
  end

  def self.constant(string)
    Object.const_get(self.camelcase(string))
  end

  def self.symbol_id(string)
    (self.underscore(string) + "_id").to_sym
  end

  def self.class_name(string)
    self.singular(self.camelcase(string))
  end

end