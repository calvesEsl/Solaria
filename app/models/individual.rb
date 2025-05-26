class Individual < Person
  validates :cpf, presence: true, uniqueness: true
end
