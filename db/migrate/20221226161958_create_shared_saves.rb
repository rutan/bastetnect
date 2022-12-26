class CreateSharedSaves < ActiveRecord::Migration[7.0]
  def change
    create_table :shared_saves do |t|
      t.references :player, null: false, foreign_key: true, index: { unique: true }
      t.text :data, null: false, default: ''

      t.timestamps
    end
  end
end
