class AddMetaInfoToPuzzle < ActiveRecord::Migration
  def change
    add_column :puzzles, :is_meta, :boolean, :default => false
    add_column :puzzles, :neighbors_needed, :integer, :default => 1
  end
end
