class CreatePuzzles < ActiveRecord::Migration
  def change
    create_table :puzzles do |t|
      t.string :puzzle_name
      t.string :long_name
      t.text :body

      t.timestamps
    end
  end
end
