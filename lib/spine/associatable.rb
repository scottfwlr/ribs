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

  def has_one_through(name, through_name, source_name)
    through = assoc_options[through_name]
    define_method(name) do
      source = through.model_class.assoc_options[source_name]

      # source_table = source_options.table_name
      # through_table = through_options.table_name
      # source_foreign_key = source_options.foreign_key
      # through_foreign_key = through_options.foreign_key
      # source_primary_id = source_options.primary_key
      # through_primary_id = through_options.primary_key

      SQL = """
        SELECT
          #{source.table_name}.*
        FROM
          #{through.table_name}
        JOIN
          #{source.table_name} ON #{through.table_name}.#{source.foreign_key} = #{source.table_name}.#{source.primary_key}
        WHERE
          #{through.table_name}.#{through.primary_id} = ?
        LIMIT
          1
      """

      results = DB.execute(SQL, send(through.foreign_key))
      
      source.model_class.parse(results).first
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end