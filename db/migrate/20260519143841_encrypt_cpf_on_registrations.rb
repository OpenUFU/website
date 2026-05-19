class EncryptCpfOnRegistrations < ActiveRecord::Migration[8.1]
  def up
    # Lê o valor plaintext direto do banco (sem passar pelo accessor criptografado),
    # depois grava via model para que o encrypts serialize corretamente.
    ActiveRecord::Encryption.config.support_unencrypted_data = true

    Registration.find_each do |r|
      plaintext = r.cpf   # com support_unencrypted_data=true, retorna o texto puro
      next if plaintext.blank?

      r.cpf = plaintext   # força re-serialização criptografada
      r.save!(validate: false)
    end
  ensure
    ActiveRecord::Encryption.config.support_unencrypted_data = false
  end

  def down
    # Descriptografa todos os CPFs de volta para texto puro.
    Registration.find_each do |r|
      plaintext = r.cpf
      r.update_column(:cpf, plaintext)
    end
  end
end
