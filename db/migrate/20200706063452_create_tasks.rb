class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end
  end
end
