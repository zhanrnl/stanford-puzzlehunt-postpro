class AddAnsweredColumnToCallin < ActiveRecord::Migration
  def change
    add_column :callins, :answered, :boolean
  end
end
