class Puzzle < ActiveRecord::Migration
  def change
    add_column :puzzles, :starts_unlocked, :boolean
  end
end
