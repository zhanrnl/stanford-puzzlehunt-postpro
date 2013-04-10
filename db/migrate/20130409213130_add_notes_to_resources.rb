class AddNotesToResources < ActiveRecord::Migration
  def change
    add_column :resources, :notes, :string
  end
end
