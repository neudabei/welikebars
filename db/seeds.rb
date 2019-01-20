# Testing seed data
#
# Tweet.create(bar: "Cause this bar is over your head \nSo you better have arms if you're gonna pull up",
#              artist: "Eminem ft Royce Da 5'9'",
#              link_to_lyrics: 'https://genius.com/Eminem-not-alike-lyrics',
#              link_to_song: 'https://www.youtube.com/watch?v=qEGI4JjLmBA',
#              approved: true)

# Tweet.create(bar: "Yo yo yo",
#              artist: "Yo Man",
#              link_to_lyrics: 'https://genius.com/yoyoyo',
#              link_to_song: 'https://www.youtube.com/watch?v=qEGI4JjLmBA',
#              approved: true)

# Tweet.create(bar: "Crappy bar",
#              artist: "Crap man",
#              link_to_lyrics: 'https://genius.com/crappy',
#              link_to_song: 'https://www.youtube.com/watch?v=qEGI4JjLmBA',
#              approved: false)

# Tweet.create(bar: "Keep it real",
#              artist: "Da King",
#              link_to_lyrics: 'https://genius.com/daking-keep-it-real',
#              link_to_song: 'https://www.youtube.com/daking',
#              approved: true, 
#              published_at: 1.day.ago)

# Tweet.create(bar: "Keep it real real",
#              artist: "Da King",
#              link_to_lyrics: 'https://genius.com/daking-keep-it-real-real',
#              link_to_song: 'https://www.youtube.com/daking2',
#              approved: true, 
#              published_at: 2.day.ago)
#
#
require 'csv'

CSV.foreach("db/bars.csv", { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all}) do |row|
  Tweet.create(row.to_hash)
end
