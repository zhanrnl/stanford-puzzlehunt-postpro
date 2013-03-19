class RemCommentsFromCallin < ActiveRecord::Migration
  def change
    remove_column :callins, :comments
  end
end
