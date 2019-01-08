class TweetService
  TIME_BETWEEN_TWEETS = 24.hours

  def send_when_due
    Tweet.next.send if next_tweet_due
  end

  private

  def next_tweet_due
    first_tweet_ever || time_of_last_tweet <= TIME_BETWEEN_TWEETS.ago
  end

  def time_of_last_tweet
    Tweet.last_sent.tweeted_at
  end

  def first_tweet_ever
    Tweet.where.not(tweeted_at: nil).empty?
  end
end
