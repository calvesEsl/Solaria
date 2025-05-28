class Individual < Person
  validates :cpf, uniqueness: true, allow_nil: true

  belongs_to :user
end
