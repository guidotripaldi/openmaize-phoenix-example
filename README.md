# Openmaize-phoenix

The latest version of Openmaize depends on Elixir 1.2.

Example of using Openmaize authentication library in a Phoenix web
application.

## Getting started with Openmaize

The following instructions show the most straightforward of getting started
with Openmaize.

1. Add openmaize to your `mix.exs` dependencies

  ```elixir
  defp deps do
    [{:openmaize, "~> 1.0.0-beta"},
    {:openmaize_jwt, "~> 0.12"]
  end
  ```

2. List `:openmaize` as an application dependency

  ```elixir
  def application do
    [applications: [:logger, :openmaize, :openmaize_jwt]]
  end
  ```

3. Run `mix do deps.get, compile`

4. Run `mix openmaize.gen.ectodb`

5. Run `mix openmaize.gen.phoenixauth`

You then need to configure Openmaize. For more information, see the documentation
for the Openmaize.Config module.

## Migrating from Devise

Follow the above instructions for generating database and authorization
modules, and then add the following lines to the config file:

    config :openmaize,
      hash_name: :encrypted_password

Some of the functions in the Authorize module depend on a `role` being
set for each user. If you are not using roles, you will need to edit
these functions before use.

### Optional password strength checker

This example uses a password strength checker which is an optional dependency of
Openmaize. If you don't want to use this, just remove the line `{:not_qwerty123, "~> 1.0"}`
from the deps in the mix.exs file.

### License

MIT.
