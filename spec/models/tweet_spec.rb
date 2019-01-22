require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe 'validations' do
    it { should validate_presence_of :bar }
  end

  describe 'publishable scope' do
    let(:published_at) { nil }
    let(:approved) { true }
    let!(:tweet_one) { Tweet.create(bar: 'This bar is over your head', artist: 'Rap god', published_at: published_at, approved: approved) }

    context "when tweet is approved and hasn't been tweeted yet" do
      it 'returns the tweet' do
        expect(Tweet.publishable).to eq([Tweet.first])
      end
    end

    context "when the tweet isn't approved" do
      let(:approved) { false }

      it 'returns no tweets' do
        expect(Tweet.publishable).to eq([])
      end
    end

    context "when the tweet has already been tweeted" do
      let(:published_at) { 1.day.ago }

      it 'returns no tweets' do
        expect(Tweet.publishable).to eq([])
      end
    end

    describe 'sorting' do
      let!(:tweet_two) { Tweet.create(bar: 'Another bar', artist: 'Rapper', published_at: published_at, approved: approved, created_at: 1.day.ago) }

      it 'sorts tweets by id by default' do
        expect(Tweet.publishable).to eq([tweet_one, tweet_two])
      end
    end
  end

  describe 'published scope' do
    let!(:tweet_one) { Tweet.create(bar: 'I think like the man behind the register', artist: 'Wu-Tang-Clan', published_at: 4.hours.ago, approved: true) }
    let!(:tweet_two) { Tweet.create(bar: 'Another day another dollar', artist: 'Raekwon', published_at: nil, approved: true) }

    it 'returns all tweets that have a published_at timestamp' do
      expect(Tweet.published).to eq([tweet_one])
    end
  end

  describe '.next' do
    let!(:tweet_three) { Tweet.create(bar: 'I think like the man behind the register', artist: 'Wu-Tang-Clan', published_at: 4.hours.ago, approved: true) }
    let!(:tweet_two) { Tweet.create(bar: 'Another day another dollar', artist: 'Raekwon', published_at: nil, approved: true) }
    let!(:tweet_one) { Tweet.create(bar: 'This bar is over your head', artist: 'Rap god', published_at: nil, approved: false) }
 
    it 'returns the tweet that should be tweeted next' do
      expect(Tweet.next).to eq(tweet_two) 
    end
  end

  describe '.last_published' do
      let!(:tweet_three) { Tweet.create(bar: 'I think like the man behind the register', artist: 'Wu-Tang-Clan', published_at: 4.hours.ago, approved: true) }
      let!(:tweet_two) { Tweet.create(bar: 'Another day another dollar', artist: 'Raekwon', published_at: 1.day.ago, approved: true) }
      let!(:tweet_one) { Tweet.create(bar: 'This bar is over your head', artist: 'Rap god', published_at: 2.days.ago, approved: true) }

    it 'returns the tweet which was published last' do
      expect(Tweet.last_published.id).to eq(tweet_three.id)
    end
  end

  describe '#publish' do
    subject { described_class.first }
    let(:twitter_client) { double(:twitter_client) }
    let(:twitter_response) { double(:twitter_response, id: 123456789012345) }

    before do
      Tweet.create(bar: 'This bar is over your head', artist: 'Rap god', published_at: nil, approved: true)
      allow(subject).to receive(:twitter_client).and_return(twitter_client)
      allow(twitter_client).to receive(:update)
      allow(subject).to receive(:twitter_response).and_return(twitter_response)
    end

    it 'publishes the tweet to twitter' do
      expect(twitter_client).to receive(:update).with("\"This bar is over your head\" - Rap god")
      subject.publish
    end

    it 'records when the tweet was published' do
      subject.publish
      expect(subject.published_at).to be_within(1.second).of Time.now
    end

    it 'records the tweet id provided by twitter after publishing' do
      subject.publish
      expect(subject.twitter_tweet_id).to eq(123456789012345)
    end
  end
end
