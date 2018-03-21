class Institute < Guts

  has_many :scientists,
    foreign_key: :institute_id,
    class_name: 'Scientist'

  finalize!
end