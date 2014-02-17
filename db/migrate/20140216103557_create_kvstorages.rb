class CreateKvstorages < ActiveRecord::Migration
  def change
    create_table :kvstorages do |t|
      t.string :key
      t.string :value
      t.integer :rating, default: 0
      t.timestamps
    end
  end
end
