class Registration < ApplicationRecord
  validates :nome_completo, presence: true
  validates :cpf, presence: true, uniqueness: true
  validates :curso, presence: true
  validates :matricula, presence: true, uniqueness: true
  validates :periodo, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
