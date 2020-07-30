class AddDeletedAtToCourseDetails < ActiveRecord::Migration[6.0]
  def change
    add_column :course_details, :deleted_at, :datetime
    add_index :course_details, :deleted_at, where: "deleted_at IS NULL"
  end
end
