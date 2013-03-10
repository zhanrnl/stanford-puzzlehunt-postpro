class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :team_name
      t.string :pass_hash
      t.string :long_name

      t.timestamps
    end
  end
end
