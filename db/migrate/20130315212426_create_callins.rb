class CreateCallins < ActiveRecord::Migration
  def change
    create_table :callins do |t|
      t.integer :puzzle_id
      t.integer :team_id
      t.string :answer
      t.string :phone_num
      t.datetime :time_called
      t.text :comments

      t.timestamps
    end
  end
end
