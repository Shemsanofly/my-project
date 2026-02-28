class CreateItineraries < ActiveRecord::Migration[7.1]
  def change
    create_table :itineraries do |t|
      t.references :user, foreign_key: true, null: true
      t.integer :budget, null: false
      t.integer :days, null: false
      t.string :trip_type, null: false
      t.text :content, null: false
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :itineraries, :trip_type
  end
end
