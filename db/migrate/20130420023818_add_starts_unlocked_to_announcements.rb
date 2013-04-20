class AddStartsUnlockedToAnnouncements < ActiveRecord::Migration
  def change
    add_column :announcements, :starts_unlocked, :boolean, :default => false
  end
end
