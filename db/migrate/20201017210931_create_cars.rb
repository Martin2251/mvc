class CreateCars < ActiveRecord::Migration[6.0]
  def change
    create_table :cars do |t|
      t.text :category
      t.integer :price
      t.references :car, null: false, foreign_key: true

      t.timestamps
    end
  end
end
