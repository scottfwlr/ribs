class Paper < Guts
  belongs_to :author,
    foreign_key: :author_id,
    class_name: 'Scientist'

  finalize!
end