class User < ApplicationRecord
  validates :is_legal_person, inclusion: { in:[true,false], message: "Deve ser selecionado"}
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
