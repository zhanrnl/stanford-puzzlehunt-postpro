class CreatePuzzles < ActiveRecord::Migration
  def change
    create_table :puzzles do |t|
      t.string :internal_name
      t.string :puzzle_name
      t.text :body

      t.timestamps
    end
  end
end
