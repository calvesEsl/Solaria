class State < ApplicationRecord
  has_many :cities

  validates :code, :name, :acronym, presence: true
end
