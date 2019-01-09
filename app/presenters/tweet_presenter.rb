class TweetPresenter
  def initialize(tweet)
    @tweet = tweet
  end

  def format
    tweet.bar + ' - ' + tweet.artist
  end

  private

  attr_reader :tweet
end
