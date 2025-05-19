class City < ApplicationRecord
  belongs_to :state

  validates :code_ibge, :name, presence: true
end
