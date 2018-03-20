require_relative 'assoc_options'

module Associatable
  def belongs_to(name, options = {})
    opts = BelongsToOptions.new(name, options)
    assoc_options[name] = opts
    define_method(name) do
      foreign_key = opts.foreign_key
      model_class = opts.model_class
      primary_key = opts.primary_key
      foreign_value = send(foreign_key)

      model_class.where(primary_key => foreign_value).first
    end
  end

  def has_many(name, options = {})
    opts = HasManyOptions.new(name, self.to_s, options)
    define_method(name) do
      foreign_key = opts.foreign_key
      model_class = opts.model_class
      primary_key = opts.primary_key
      primary_value = send(primary_key)

      model_class.where(foreign_key => primary_value)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end