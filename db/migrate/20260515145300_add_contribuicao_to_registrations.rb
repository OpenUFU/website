class AddContribuicaoToRegistrations < ActiveRecord::Migration[8.1]
  def change
    add_column :registrations, :contribuicao, :text
  end
end
