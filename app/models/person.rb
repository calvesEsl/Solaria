class Person < ApplicationRecord
  self.inheritance_column = :type

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  belongs_to :city, inverse_of: :people, optional: true
  belongs_to :user
end
