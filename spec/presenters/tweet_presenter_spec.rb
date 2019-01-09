require 'rails_helper'

RSpec.describe TweetPresenter do
  let(:tweet) { double(:tweet, bar: "Please don't cry for me Argentina", artist: 'Evita') }
  subject { described_class.new(tweet) }

  describe '#format' do
    it 'returns the bar and artist of the tweet connected by a dash' do
      expect(subject.format).to eq("Please don't cry for me Argentina - Evita") 
    end
  end
end
