class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.references :game, null: false, foreign_key: true
      t.string :name, limit: 32, null: false
      t.integer :status, default: 0
      t.datetime :last_play_at, precision: 6, null: false, default: -> { 'NOW()' }

      t.timestamps
    end
    add_index :players, :status
    add_index :players, :last_play_at
  end
end
