class Company < Person
  validates :cnpj, presence: true, uniqueness: true
end
