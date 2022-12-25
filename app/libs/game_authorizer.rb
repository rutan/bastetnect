# frozen_string_literal: true

class GameAuthorizer
  attr_reader :game
  attr_accessor :player

  def initialize(game, player = nil)
    @game = game
    @player = player
  end

  def load_player!(token)
    @player = load_player_from_token!(token)
  end

  def generate_token(expired_at: 100.years.since)
    return nil unless @player

    JWT.encode(generate_claims(expired_at), rsa, 'RS256')
  end

  private

  def rsa
    @rsa ||= OpenSSL::PKey::RSA.new(@game.pem)
  end

  def generate_claims(expired_at)
    {
      iss: game.name,
      sub: @player&.id,
      exp: expired_at.to_i,
      iat: Time.zone.now.to_i,
      generation: @player&.created_at.to_i
    }
  end

  def load_player_from_token!(token)
    payload = decode_token!(token)
    validate_payload!(payload)

    player = Player.find_by(id: payload['sub'], game_id: game.id)
    validate_player!(payload, player)

    player
  end

  def decode_token!(token)
    JWT.decode(token, rsa.public_key, true, algorithm: 'RS256').first
  rescue JWT::DecodeError => e
    raise UnauthorizedError, e.message
  end

  def validate_payload!(payload)
    raise UnauthorizedError, 'invalid game name' unless payload['iss'] == @game.name
    raise UnauthorizedError, 'invalid sub' unless payload['sub']
  end

  def validate_player!(payload, player)
    raise UnauthorizedError, 'invalid sub' unless player
    raise UnauthorizedError, 'invalid generation' unless payload['generation'] == player.created_at.to_i
  end
end
