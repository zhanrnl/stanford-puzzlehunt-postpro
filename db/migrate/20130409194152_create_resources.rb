class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :original
      t.string :hashed

      t.timestamps
    end
  end
end
