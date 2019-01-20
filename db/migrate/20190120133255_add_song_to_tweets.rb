class AddSongToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :song, :string
  end
end
