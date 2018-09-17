# Mailrex

Simple code kata for Elixir. Fire off emails via HTTP API with built in
queuing system.

# Project setup

This project assumes you're using Elixir 1.7 or higher.

```
mix deps.get
mix test
```

You should see all tests pass green.

# Running the project

Create a `.env` file at the root of the project and place the keys:

```
export MAILGUN_API_KEY=
export MAILGUN_DOMAIN=
```

Then load that .env file and run the server.

```
source .env
mix phx.server
```

# Accessing the API

Download Postman: https://www.getpostman.com/

Import the file `Mailrex Local.postman_collection.json`

You'll see the endpoints and they're used there.

# Todo

- [x] Setup + Call Mailgun
- [x] Templatize Emails
- [x] Create a REST API
- [ ] Add a queue

For the Queue feature, I wrote an example GenServer implementation that would pick unsent
items from a Redis queue, process the email, then mark it for deletion.
