class Inflect

  def self.new
    self
  end

  def self.table(string)
    self.plural(string.scan(/[A-Z][a-z]+/).map(&:downcase).join("_"))
  end

  def self.plural(string)
    string + "s"
  end

end