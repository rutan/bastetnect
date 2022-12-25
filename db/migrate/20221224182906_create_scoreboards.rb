class CreateScoreboards < ActiveRecord::Migration[7.0]
  def change
    create_table :scoreboards do |t|
      t.references :game, null: false, foreign_key: true
      t.string :name, limit: 64, null: false
      t.integer :rank_order, limit: 1, null: false
      t.integer :index, limit: 1, null: false
      t.boolean :is_overwrite_best_score, default: false

      t.timestamps
    end
    add_index :scoreboards, [:game_id, :index], unique: true
  end
end
