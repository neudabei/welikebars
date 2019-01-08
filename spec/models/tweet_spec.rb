require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'tweetable scope' do
    let(:tweeted_at) { nil }
    let(:approved) { true }
    let!(:tweet_one) { Tweet.create(bar: 'This bar is over your head', artist: 'Rap god', tweeted_at: tweeted_at, approved: approved) }

    context "when tweet is approved and hasn't been tweeted yet" do
      it 'returns the tweet' do
        expect(Tweet.tweetable).to eq([Tweet.first])
      end
    end

    context "when the tweet isn't approved" do
      let(:approved) { false }

      it 'returns no tweets' do
        expect(Tweet.tweetable).to eq([])
      end
    end

    context "when the tweet has already been tweeted" do
      let(:tweeted_at) { 1.day.ago }

      it 'returns no tweets' do
        expect(Tweet.tweetable).to eq([])
      end
    end

    describe 'sorting' do
      let!(:tweet_two) { Tweet.create(bar: 'Another bar', artist: 'Rapper', tweeted_at: tweeted_at, approved: approved, created_at: 1.day.ago) }

      it 'sorts tweets by id by default' do
        expect(Tweet.tweetable).to eq([tweet_one, tweet_two])
      end
    end
  end
end
