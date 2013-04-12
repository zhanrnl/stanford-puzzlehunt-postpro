class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :team_id
      t.text :question
      t.string :phone_num
      t.datetime :time_called
      t.boolean :answered

      t.timestamps
    end
  end
end
