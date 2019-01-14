namespace :twitter do
  desc "Publish the next tweet when it is due. Should be run via Cron job."
  task publish_when_due: :environment do
    tweet_service = TweetService.new
    tweet_service.publish_when_due
  end
end
