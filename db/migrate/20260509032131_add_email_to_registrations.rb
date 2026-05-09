class AddEmailToRegistrations < ActiveRecord::Migration[8.1]
  def change
    add_column :registrations, :email, :string
  end
end
