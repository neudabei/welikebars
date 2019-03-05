require 'rails_helper'

RSpec.describe TweetService do
  subject { described_class.new }
  let(:tweet) { double(:tweet, publish: nil) }

  before do
    allow(Tweet).to receive(:next).and_return(tweet)
  end

  describe '#publish_when_due' do
    context 'when the next tweet is due because the last tweet was published over 24 hours ago' do
      before do
        Tweet.create(bar: "Keep it real",
                     artist: "Da King",
                     link_to_lyrics: 'https://genius.com/daking-keep-it-real',
                     link_to_song: 'https://www.youtube.com/daking',
                     approved: true, 
                     published_at: 25.hours.ago)

        Tweet.create(bar: "Cause this bar is over your head \nSo you better have arms if you're gonna pull up",
                     artist: "Eminem ft Royce Da 5'9'",
                     link_to_lyrics: 'https://genius.com/Eminem-not-alike-lyrics',
                     link_to_song: 'https://www.youtube.com/watch?v=qEGI4JjLmBA',
                     approved: true)
      end

      it 'publishs a tweet' do
        expect(tweet).to receive(:publish)
        subject.publish_when_due
      end
    end

    context 'when it is the first tweet to be published' do
      before do
        Tweet.create(bar: "Cause this bar is over your head \nSo you better have arms if you're gonna pull up",
                     artist: "Eminem ft Royce Da 5'9'",
                     link_to_lyrics: 'https://genius.com/Eminem-not-alike-lyrics',
                     link_to_song: 'https://www.youtube.com/watch?v=qEGI4JjLmBA',
                     approved: true)
      end

      it 'publishs a tweet' do
        expect(tweet).to receive(:publish)
        subject.publish_when_due
      end
    end

    context 'when no tweets are due for publishing' do
      it 'returns nil' do
        expect(subject.publish_when_due).to eq(nil)
      end
    end

    context 'when no tweets are available for publishing' do
      before do
        allow(Tweet).to receive(:next).and_return(nil)
      end

      it 'does not publish a tweet' do
        expect(nil).not_to receive(:publish)
        subject.publish_when_due
      end
    end
  end
end
