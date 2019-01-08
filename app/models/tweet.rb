class Tweet < ApplicationRecord
  scope :tweetable, -> { where(tweeted_at: nil, approved: true) }
end
