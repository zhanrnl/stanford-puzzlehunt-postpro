class AddNotesToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :notes, :text
  end
end
