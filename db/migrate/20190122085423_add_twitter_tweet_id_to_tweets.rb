class AddTwitterTweetIdToTweets < ActiveRecord::Migration[5.2]
  def change
    add_column :tweets, :twitter_tweet_id, :bigint
  end
end
