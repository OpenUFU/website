class CreateRegistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :registrations do |t|
      t.string :nome_completo
      t.string :cpf
      t.string :curso
      t.string :matricula
      t.string :periodo

      t.timestamps
    end
  end
end
