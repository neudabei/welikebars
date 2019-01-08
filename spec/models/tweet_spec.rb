require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'validations' do
    it { should validate_presence_of :bar }
  end

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

  describe 'published scope' do
    let!(:tweet_one) { Tweet.create(bar: 'I think like the man behind the register', artist: 'Wu-Tang-Clan', tweeted_at: 4.hours.ago, approved: true) }
    let!(:tweet_two) { Tweet.create(bar: 'Another day another dollar', artist: 'Raekwon', tweeted_at: nil, approved: true) }

    it 'returns all tweets that have a tweeted_at timestamp' do
      expect(Tweet.published).to eq([tweet_one])
    end
  end

  describe '.next' do
    let!(:tweet_three) { Tweet.create(bar: 'I think like the man behind the register', artist: 'Wu-Tang-Clan', tweeted_at: 4.hours.ago, approved: true) }
    let!(:tweet_two) { Tweet.create(bar: 'Another day another dollar', artist: 'Raekwon', tweeted_at: nil, approved: true) }
    let!(:tweet_one) { Tweet.create(bar: 'This bar is over your head', artist: 'Rap god', tweeted_at: nil, approved: false) }
 
    it 'returns the tweet that should be tweeted next' do
      expect(Tweet.next).to eq(tweet_two) 
    end
  end

  describe '.last_published' do
      let!(:tweet_three) { Tweet.create(bar: 'I think like the man behind the register', artist: 'Wu-Tang-Clan', tweeted_at: 4.hours.ago, approved: true) }
      let!(:tweet_two) { Tweet.create(bar: 'Another day another dollar', artist: 'Raekwon', tweeted_at: 1.day.ago, approved: true) }
      let!(:tweet_one) { Tweet.create(bar: 'This bar is over your head', artist: 'Rap god', tweeted_at: 2.days.ago, approved: true) }

    it 'returns the tweet which was published last' do
      expect(Tweet.last_published.id).to eq(tweet_three.id)
    end
  end

  describe '#publish' do
    subject { described_class.first }
    let(:twitter_client) { double(:twitter_client) }

    before do
      Tweet.create(bar: 'This bar is over your head', artist: 'Rap god', tweeted_at: nil, approved: true)
      allow(subject).to receive(:twitter_client).and_return(twitter_client)
      allow(twitter_client).to receive(:update).with(Tweet.first.bar)
    end

    it 'publishs the tweet to twitter' do
      expect(twitter_client).to receive(:update).with(Tweet.first.bar)
      subject.publish
    end

    it 'records when the tweet was published' do
      subject.publish
      expect(subject.tweeted_at).to be_within(1.second).of Time.now
    end
  end
end
