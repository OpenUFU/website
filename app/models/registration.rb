class Registration < ApplicationRecord
  # CPF criptografado em repouso. deterministic: true permite validar unicidade.
  encrypts :cpf, deterministic: true

  validates :nome_completo, presence: true
  validates :cpf, presence: true, uniqueness: true
  validates :curso, presence: true
  validates :matricula, presence: true, uniqueness: true
  validates :periodo, presence: true,
                      numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 14 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :contribuicao, length: { maximum: 5000 }, allow_blank: true
end
