class CreateScoreboardItems < ActiveRecord::Migration[7.0]
  def change
    create_table :scoreboard_items do |t|
      t.references :scoreboard, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.bigint :score, default: 0

      t.timestamps
    end
    add_index :scoreboard_items, [:scoreboard_id, :player_id], unique: true
  end
end
