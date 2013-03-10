class CreateSolves < ActiveRecord::Migration
  def change
    create_table :solves do |t|
      t.datetime :time_solved
      t.references :puzzle
      t.references :team

      t.timestamps
    end
  end
end
