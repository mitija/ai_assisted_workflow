# API Reference

Endpoint documentation for the REST API. All endpoints return JSON and require the `Content-Type: application/json` header.

## Authentication

All requests require a Bearer token in the `Authorization` header:

```
Authorization: Bearer <your-token>
```

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Tokens can be generated from the dashboard. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

## GET /users

Returns a list of users. Supports pagination via `page` and `limit` query parameters.

**Response:**

```json
{
  "users": [
    { "id": 1, "name": "Alice", "email": "alice@example.com" },
    { "id": 2, "name": "Bob", "email": "bob@example.com" }
  ],
  "total": 42
}
```

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

## POST /users

Creates a new user. Requires `name` and `email` in the request body.

**Request:**

```json
{
  "name": "Charlie",
  "email": "charlie@example.com"
}
```

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Make sure to complete [[setup#installation]] before testing this endpoint.

## DELETE /users/:id

Deletes a user by ID. This action is irreversible.

Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. See [[setup#configuration]] for database setup.

Back to [Index](./index.md) | See [Setup Guide](./setup.md) | Jump to [Installation](./setup.md#installation)

Related: [[index]], [[setup]], [[setup#prerequisites]]
