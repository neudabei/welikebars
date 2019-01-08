class ChangeTweetedAtToPublishedAt < ActiveRecord::Migration[5.2]
  def change
    rename_column :tweets, :tweeted_at, :published_at
  end
end
