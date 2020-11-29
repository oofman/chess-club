class CreateMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :members do |t|
      t.string :name
      t.string :email
      t.date   :dob
      t.integer :num_games, default: 0
      t.integer :current_rank

      t.timestamps
    end

    add_index :members, :email, unique: true
  end
end
