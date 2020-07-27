class AddDeleteToCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :isdeleted, :integer, default: 0
  end
end
