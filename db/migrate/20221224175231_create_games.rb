class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name, limit: 32, null: false
      t.string :version, limit: 32, default: '0.0.0'
      t.integer :status, default: 0
      t.text :pem, null: false

      t.timestamps
    end
    add_index :games, :name, unique: true
  end
end
