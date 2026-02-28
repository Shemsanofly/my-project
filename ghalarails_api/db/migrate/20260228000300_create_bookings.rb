class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :itinerary, null: false, foreign_key: true
      t.references :tour, null: true, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :guests, null: false, default: 1
      t.string :status, null: false, default: "pending"
      t.decimal :total_amount, precision: 12, scale: 2, null: false, default: 0
      t.text :special_requests

      t.timestamps
    end

    add_index :bookings, :status
  end
end
