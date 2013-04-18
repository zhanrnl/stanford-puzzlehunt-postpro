class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :body
      t.references :puzzle
      t.integer :order

      t.timestamps
    end
    add_index :announcements, :puzzle_id
  end
end
