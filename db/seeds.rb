# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Tweet.create(bar: "Cause this bar is over your head \nSo you better have arms if you're gonna pull up",
             artist: "Eminem ft Royce Da 5'9'",
             link_to_lyrics: 'https://genius.com/Eminem-not-alike-lyrics',
             link_to_song: 'https://www.youtube.com/watch?v=qEGI4JjLmBA',
             approved: true)

Tweet.create(bar: "Yo yo yo",
             artist: "Yo Man",
             link_to_lyrics: 'https://genius.com/yoyoyo',
             link_to_song: 'https://www.youtube.com/watch?v=qEGI4JjLmBA',
             approved: true)

Tweet.create(bar: "Crappy bar",
             artist: "Crap man",
             link_to_lyrics: 'https://genius.com/crappy',
             link_to_song: 'https://www.youtube.com/watch?v=qEGI4JjLmBA',
             approved: false)

Tweet.create(bar: "Keep it real",
             artist: "Da King",
             link_to_lyrics: 'https://genius.com/daking-keep-it-real',
             link_to_song: 'https://www.youtube.com/daking',
             approved: true, 
             tweeted_at: 1.day.ago)

Tweet.create(bar: "Keep it real real",
             artist: "Da King",
             link_to_lyrics: 'https://genius.com/daking-keep-it-real-real',
             link_to_song: 'https://www.youtube.com/daking2',
             approved: true, 
             tweeted_at: 2.day.ago)
