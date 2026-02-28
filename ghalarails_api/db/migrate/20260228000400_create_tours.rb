class CreateTours < ActiveRecord::Migration[7.1]
  def change
    create_table :tours do |t|
      t.string :title, null: false
      t.text :description
      t.decimal :price, precision: 12, scale: 2, null: false, default: 0
      t.integer :duration_days, null: false
      t.string :trip_type, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :tours, :trip_type
    add_index :tours, :active
  end
end
