class CreateGameSignals < ActiveRecord::Migration[7.0]
  def change
    create_table :game_signals do |t|
      t.references :game, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: {to_table: :players}
      t.text :data, null: false

      t.timestamps
    end
  end
end
