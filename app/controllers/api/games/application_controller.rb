# frozen_string_literal: true

module Api
  module Games
    class ApplicationController < ::Api::ApplicationController
      before_action :game
      before_action :require_updatable_game!, if: :update_request?
      before_action :require_check_cors!, if: :update_request?

      private

      def game
        @game ||= Game.visible.find_by!(name: params[:game_name])
      end

      def current_player
        return @current_player if instance_variable_defined?(:@current_player)
        return nil unless jwt_token

        authorizer = GameAuthorizer.new(game)
        authorizer.load_player!(jwt_token)
        @current_player = authorizer.player
      end

      def jwt_token
        return nil unless request.headers['Authorization']

        words = request.headers['Authorization'].to_s.split(/\s+/)
        return nil unless words.size == 2
        return nil unless words.first == 'Bearer'

        words.last
      end

      def require_updatable_game!
        raise ForbiddenError, 'this game is suspended' if game.suspended?
      end

      def require_check_cors!
        origin = request.headers['Origin']
        requested_with = request.headers['X-Requested-With']
        CorsChecker.new(origin:, requested_with:).check!
        return if origin.blank?

        raise ForbiddenError, 'this origin is not allowed' unless game.allowed_origins.pluck(:origin).include?(origin)
      end

      def require_login!
        raise UnauthorizedError, 'require valid Authorization header' unless current_player
      end
    end
  end
end
