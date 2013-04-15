class AddXyToPuzzle < ActiveRecord::Migration
  def change
    add_column :puzzles, :xcoord, :integer
    add_column :puzzles, :ycoord, :integer
  end
end
