class AddSolutionToPuzzle < ActiveRecord::Migration
  def change
    add_column :puzzles, :solution, :text
  end
end
