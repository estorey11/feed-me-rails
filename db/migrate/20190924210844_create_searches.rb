class CreateSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :searches do |t|
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.integer :zip
      t.string :restaurant
      t.string :ghUrl
      t.string :ghName
      t.string :slUrl
      t.string :slName
      t.string :pmUrl
      t.string :pmName

      t.timestamps
    end
  end
end
