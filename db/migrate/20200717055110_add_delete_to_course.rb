class AddDeleteToCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :isdeleted, :boolean, default: 0
  end
end
