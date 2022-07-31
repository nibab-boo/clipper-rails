class AddTitleToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :title, :string
  end
end
