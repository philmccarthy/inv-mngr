class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items, id: :uuid do |t|
      t.string :name
      t.string :description
      t.string :category
      t.integer :initial_stock

      t.timestamps
    end
  end
end
