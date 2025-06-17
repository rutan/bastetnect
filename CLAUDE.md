# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bastetnect is a Ruby on Rails 7 API-only application that serves as a game API server. It provides backend services for multiplayer games including player management, real-time signaling, scoreboards, and data persistence.

**Tech Stack:**
- Ruby 3.2.2, Rails 7.0.4
- PostgreSQL database
- Docker for development
- JWT authentication with RSA key pairs per game
- RSpec for testing

## Development Commands

All development commands should be run through Docker Compose:

```bash
# Start development server
docker compose -f docker-compose.dev.yml up

# Run tests
docker compose -f docker-compose.dev.yml run --rm app bundle exec rspec

# Run specific test file
docker compose -f docker-compose.dev.yml run --rm app bundle exec rspec spec/path/to/spec.rb

# Run linter
docker compose -f docker-compose.dev.yml run --rm app bundle exec rubocop

# Run database migrations
docker compose -f docker-compose.dev.yml run --rm app bundle exec rake db:migrate

# Access Rails console
docker compose -f docker-compose.dev.yml run --rm app bundle exec rails c

# Install new gems (after updating Gemfile)
docker compose -f docker-compose.dev.yml run --rm app bundle install
```

## Architecture Overview

### API Structure
The API follows RESTful conventions with nested resources under `/api/`:

- `/api/games` - Game management
- `/api/games/:game_name/current_player` - Current player operations
- `/api/games/:game_name/players` - Player listing and management
- `/api/games/:game_name/game_signals` - Game-wide signals
- `/api/games/:game_name/players/:id/player_signals` - Player-to-player signals
- `/api/games/:game_name/scoreboards/:index` - Scoreboard management
- `/api/games/:game_name/active_player_count` - Active player metrics

### Key Design Patterns

1. **Authentication Flow**:
   - Each game has its own RSA key pair (stored as PEM in database)
   - JWT tokens are signed with the game's private key
   - Tokens are validated using the game's public key

2. **Controller Organization**:
   - All API controllers inherit from `Api::BaseController`
   - Nested resources use modules (e.g., `Api::Games::PlayersController`)
   - Common concerns are extracted to parent controllers

3. **Response Format**:
   - JSON responses use JB templates in `app/views/api/`
   - Pagination uses Kaminari with standardized meta information
   - Errors follow a consistent format with appropriate HTTP status codes

4. **CORS Configuration**:
   - Games have `allowed_origins` field for CORS whitelisting
   - Global CORS allows all origins for `/api/*` endpoints
   - Per-game CORS validation in `Libs::Cors`

### Important Models

- **Game**: Central entity with status (active/hidden/frozen/dead), RSA keys, and CORS origins
- **Player**: Belongs to a game, has encrypted ID, tracks last_play_at
- **GameSignal/PlayerSignal**: Message passing between game entities
- **Scoreboard/ScoreboardItem**: Leaderboard functionality with best score tracking
- **SharedSave**: Player data persistence

### Custom Libraries

- `Libs::Authorization`: JWT token generation and validation
- `Libs::Cors`: CORS origin validation per game
- `Errors::ApiError`: Base error class for API exceptions

### Testing Approach

- Request specs for API endpoints in `spec/requests/api/`
- Model specs for business logic
- Use FactoryBot for test data
- Tests focus on API response format and status codes