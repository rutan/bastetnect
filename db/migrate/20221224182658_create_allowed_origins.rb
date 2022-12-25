class CreateAllowedOrigins < ActiveRecord::Migration[7.0]
  def change
    create_table :allowed_origins do |t|
      t.references :game, null: false, foreign_key: true
      t.string :origin, null: false

      t.timestamps
    end
    add_index :allowed_origins, [:game_id, :origin], unique: true
  end
end
