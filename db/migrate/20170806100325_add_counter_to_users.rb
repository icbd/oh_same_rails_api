class AddCounterToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :channel_count, :integer, default: 0
    add_column :users, :content_count, :integer, default: 0
  end
end
