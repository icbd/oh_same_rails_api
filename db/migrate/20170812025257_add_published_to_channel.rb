class AddPublishedToChannel < ActiveRecord::Migration[5.1]
  def change
    add_column :channels, :published, :boolean, default: true
  end
end
