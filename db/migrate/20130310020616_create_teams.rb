class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :internal_name
      t.string :pass_hash
      t.string :team_name

      t.timestamps
    end
  end
end
