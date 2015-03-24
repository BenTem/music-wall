class AddVotedColumn < ActiveRecord::Migration
  def change
    add_column :songs_users, :voted, :boolean
  end
end
