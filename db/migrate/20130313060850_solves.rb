class Solves < ActiveRecord::Migration
  def change
    remove_column :solves, :teams_id
    remove_column :solves, :puzzles_id
    add_column :solves, :team_id, :integer
    add_column :solves, :puzzle_id, :integer
  end
end
