module Searchable

  def where(params)
    cond_line = params.keys.map { |col| "#{col} = ?"}.join(' AND ')
    sql = """
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{cond_line}
    """

    self.parse(DB.execute(sql, *params.values))
  end
end