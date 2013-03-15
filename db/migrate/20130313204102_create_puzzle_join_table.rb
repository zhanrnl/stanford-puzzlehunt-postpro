class CreatePuzzleJoinTable < ActiveRecord::Migration
  def up
    create_table :puzzle_links do |t|
      t.integer :puzzle1_id
      t.integer :puzzle2_id
    end
  end

  def down
    drop_table :puzzle_links
  end
end
