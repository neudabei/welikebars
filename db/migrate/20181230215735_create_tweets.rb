class CreateTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets do |t|
      t.string :bar
      t.string :artist
      t.string :link_to_lyrics
      t.string :link_to_song
      t.boolean :approved
      t.timestamp :tweeted_at
      t.timestamps
    end
  end
end
