class Scientist < Guts

  belongs_to :institute,
    foreign_key: :institute_id,
    class_name: 'Institute'

  has_many :papers,
    foreign_key: :author_id,
    class_name: 'Paper'

  finalize!
end