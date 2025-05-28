class User < ApplicationRecord
  validates :is_legal_person, inclusion: { in:[true,false], message: "Deve ser selecionado"}
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :individual, -> { where(type: 'Individual') }, class_name: 'Person', dependent: :destroy

  after_commit :create_individual_record, on: :create

  private

  def create_individual_record
    return if is_legal_person || individual.present?

    create_individual(name: name.presence || "Sem nome", email: email)
  end
end
