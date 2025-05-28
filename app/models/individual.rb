class Individual < Person
  validates :cpf, presence: true, uniqueness: true

  belongs_to :user
end
