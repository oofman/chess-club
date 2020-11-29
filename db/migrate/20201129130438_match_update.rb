class MatchUpdate < ActiveRecord::Migration[6.0]
  def change
    remove_column :matches, :user_won
    add_column :matches, :match_status, :string
  end
end
