class CreateSolves < ActiveRecord::Migration
  def change
    create_table :solves do |t|
      t.datetime :time_solved
      t.references :puzzles
      t.references :teams

      t.timestamps
    end
  end
end
