`rm db/papers.db`
`cat db/papers.sql | sqlite3 db/papers.db`

require_relative "../lib/guts"

class Paper < Guts
  belongs_to :author,
    foreign_key: :author_id,
    class_name: 'Scientist'

  finalize!
end


class Scientist < Guts
  belongs_to :institute,
    foreign_key: :institute_id,
    class_name: 'Institute'

  has_many :papers,
    foreign_key: :author_id,
    class_name: 'Paper'

  finalize!
end

class Institute < Guts 

  finalize!
end

