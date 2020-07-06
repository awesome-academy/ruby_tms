class CreateSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
      t.string :name
      t.integer :duration
      t.string :description
      t.integer :status

      t.timestamps
    end
  end
end
