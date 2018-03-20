require_relative 'inflector'

class AssocOptions 
  attr_accessor :foreign_key, :class_name, :primary_key

  def model_class
    Inflect.constant(class_name)
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, foreign_key: nil, class_name: nil, primary_key: :id)
    @foreign_key = foreign_key || Inflect.symbol_id(name)
    @class_name = class_name || Inflect.class_name(name)
    @primary_key = primary_key
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, foreign_key: nil, class_name: nil, primary_key: :id)
    @foreign_key = foreign_key || Inflect.symbol_id(self_class_name)
    @class_name = class_name || Inflect.class_name(name)
    @primary_key = primary_key
  end
end
