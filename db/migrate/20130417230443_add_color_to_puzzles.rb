class AddColorToPuzzles < ActiveRecord::Migration
  def change
    add_column :puzzles, :color, :string
  end
end
