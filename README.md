# Bastetnect

Bastetnect is a Ruby on Rails API-only application that provides backend infrastructure for asynchronous multiplayer games. Inspired by Game Atsumaru, it handles player authentication, signaling, and data persistence with a clean REST API interface.

## Features

- **Multi-Game Support**: Host multiple games with independent player bases
- **JWT Authentication**: Secure authentication using per-game RSA key pairs
- **Asynchronous Signaling**: Enable asynchronous multiplayer communication between players
- **Player Data Persistence**: Store up to 4KB of data per player
- **CORS Management**: Per-game CORS configuration for web-based games
- **Game Status Control**: Manage game lifecycle (active, hidden, suspended, dead)

## Tech Stack

- Ruby on Rails
- PostgreSQL
- Docker & Docker Compose
- JWT with RSA encryption
- RSpec for testing

## Getting Started

### Prerequisites

- Docker and Docker Compose
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/rutan/bastetnect.git
cd bastetnect
```

2. Copy the environment variables:
```bash
cp .env-sample .env
```

3. Build the Docker containers:
```bash
docker compose -f docker-compose.dev.yml build
```

4. Install dependencies:
```bash
docker compose -f docker-compose.dev.yml run --rm app bundle install
```

5. Set up the database:
```bash
docker compose -f docker-compose.dev.yml run --rm app bundle exec rake db:create db:migrate db:seed
```

6. Start the development server:
```bash
docker compose -f docker-compose.dev.yml up
```

The API will be available at `http://localhost:3000`.

## API Documentation

### Authentication

All authenticated endpoints require a JWT token in the Authorization header:
```
Authorization: Bearer <jwt_token>
```

Tokens are obtained by creating a player through the API.

### Base URL

All API endpoints are prefixed with `/api/`.

### Endpoints

#### Games

- **List Games**
  ```
  GET /api/games
  ```
  Returns all visible games.

- **Get Game Details**
  ```
  GET /api/games/:game_name
  ```

#### Players

- **Create Player** (Get JWT Token)
  ```
  POST /api/games/:game_name/current_player
  ```
  Creates a new player and returns a JWT token.

- **Get Current Player**
  ```
  GET /api/games/:game_name/current_player
  ```
  Requires authentication.

- **Update Current Player**
  ```
  PUT /api/games/:game_name/current_player
  ```
  Update player information (name, data).

- **List Players**
  ```
  GET /api/games/:game_name/players
  ```
  Returns paginated list of players.

#### Signaling (Asynchronous Multiplayer Communication)

- **Get Game Signals**
  ```
  GET /api/games/:game_name/game_signals?after_id=:id
  ```
  Retrieve game-wide signals sent after the specified ID.

- **Send Game Signal**
  ```
  POST /api/games/:game_name/game_signals
  Body: { "body": { "type": "event", "data": {...} } }
  ```

- **Get Player Signals**
  ```
  GET /api/games/:game_name/current_player/player_signals?after_id=:id
  ```
  Retrieve signals sent to the current player.

- **Send Player Signal**
  ```
  POST /api/games/:game_name/players/:player_id/player_signals
  Body: { "body": { "type": "message", "data": {...} } }
  ```

#### Other

- **Get Active Player Count**
  ```
  GET /api/games/:game_name/active_player_count
  ```
  Returns count of recently active players.

### Response Format

All successful responses follow this format:
```json
{
  "status": "success",
  "data": {
    // Response data
  }
}
```

Paginated responses include metadata:
```json
{
  "status": "success",
  "data": [...],
  "meta": {
    "total_count": 100,
    "page": 1,
    "per_page": 25
  }
}
```

Error responses:
```json
{
  "error": "Error message",
  "status": "error"
}
```

## Development

### Running Tests

```bash
# Run all tests
docker compose -f docker-compose.dev.yml run --rm app bundle exec rspec

# Run specific test file
docker compose -f docker-compose.dev.yml run --rm app bundle exec rspec spec/requests/api/games_spec.rb
```

### Linting

```bash
docker compose -f docker-compose.dev.yml run --rm app bundle exec rubocop
```

### Rails Console

```bash
docker compose -f docker-compose.dev.yml run --rm app bundle exec rails c
```

### Database Operations

```bash
# Run migrations
docker compose -f docker-compose.dev.yml run --rm app bundle exec rake db:migrate

# Rollback migration
docker compose -f docker-compose.dev.yml run --rm app bundle exec rake db:rollback

# Reset database
docker compose -f docker-compose.dev.yml run --rm app bundle exec rake db:reset
```

## Game Configuration

When creating a game in the database, you can configure:

- `name`: Unique identifier for the game
- `version`: Game version string
- `status`: `active`, `hidden`, `suspended`, or `dead`
- `allowed_origins`: Array of allowed CORS origins (e.g., `["https://example.com"]`)

Games automatically receive RSA key pairs for JWT token signing upon creation.

## Environment Variables

See `.env-sample` for required environment variables:

- `DATABASE_URL`: Production database connection
- `DEVELOPMENT_DATABASE_URL`: Development database connection
- `TEST_DATABASE_URL`: Test database connection

## Security Considerations

- Each game has its own RSA key pair for JWT signing
- CORS is configured per-game with explicit origin whitelisting
- Write operations require `X-Requested-With` header
- Suspended games block write operations but allow reads
- Rate limiting is implemented via rack-attack

## License

This project is licensed under the MIT License - see the LICENSE file for details.