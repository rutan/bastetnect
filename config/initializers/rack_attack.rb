# frozen_string_literal: true

# register player
Rack::Attack.throttle('POST /api/games/:game_name/current_player', limit: 3, period: 5) do |request|
  next unless request.post?

  match = request.path.match(%r{/api/games/(?<game_name>[^/]{1,64})/current_player/?/A\z})
  next unless match

  "#{match[:game_name]}/#{request.ip}"
end

# increase play count
Rack::Attack.throttle('POST /api/games/:game_name/play_start', limit: 1, period: 60) do |request|
  next unless request.post?

  match = request.path.match(%r{/api/games/(?<game_name>[^/]{1,64})/play_start/?/A\z})
  next unless match

  "#{match[:game_name]}/#{request.ip}"
end

# too many response
Rack::Attack.throttled_responder = ->(_request) do
  json = {
    status: 'error',
    message: 'too many access'
  }.to_json

  headers = {
    'Content-Type' => 'application/json'
  }

  [429, headers, [json]]
end
