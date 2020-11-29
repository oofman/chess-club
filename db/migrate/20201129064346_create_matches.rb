class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.integer :user_id
      t.integer :user_rank
      t.integer :user_rank_new
      t.integer :challenger_id
      t.integer :challenger_rank
      t.integer :challenger_rank_new
      t.boolean :user_won, default: false
      
      t.timestamps null: false
    end
  end
end
