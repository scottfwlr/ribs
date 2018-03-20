module Searchable

  def where(params)
    cond_line = params.keys.map { |col| "#{col} = ?"}.join(' AND ')
    SQL = """
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{cond_line}
    """

    self.parse(DB.execute(SQL, *params.values))
  end
end