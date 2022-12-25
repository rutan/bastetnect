# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


Game.create!(name: 'test').tap do |game|
  scoreboard = Scoreboard.create!(game:, name: 'scoreboard', index: 1, rank_order: :desc)

  100.times do |i|
    Player.create!(game:, name: "player-#{i}", shared_data: "#{{data: i}.to_json}").tap do |player|
      ScoreboardItem.create!(scoreboard:, player:, score: rand(100000))
    end
  end

  players = game.players.to_a
  500.times do |i|
    sender, receiver = players.sample(2)
    GameSignal.create!(game:, sender:, data: "#{{data: i}.to_json}")
    PlayerSignal.create!(player: receiver, sender: sender, data: "#{{data: i}.to_json}")
  end
end
