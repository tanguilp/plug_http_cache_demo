# PlugHTTPCacheDemo

This is a demo app for [`plug_http_cache`](https://github.com/tanguilp/plug_http_cache).

This is composed of:
- an Elixir project that uses `plug_http_cache` to cache results of expensive fibonacci
calculations
- a Tsung script that sends a lot of request locally to the Elixir project
- a `docker-compose.yml` file that allows launching 3 instances of the Elixir project
along with a nice Grafana dashboard that shows realtime stats of the caching services

## Install & launch

Requires OTP26+.

Type

```shell
mix deps.get
```
in the shell to install dependencies.

### Launch locally

Type `mix phx.server` (or `iex -S mix phx.server` to have a shell) and visit
[localhost:4000](http://localhost:4000).

In some browsers, typing the F5 key forces a refresh of the page (that is, without
caching). You better type the Enter key in the address bar to make sure cached
versions are used.

It launches with the memory `http_cache_store_native` by default. To use the
`http_cache_store_disk` backend instead, switch to the `disk-backend` branch
(files will be saved in `/tmp/http_cache/`).

### Launch through `docker`

Type:

```shell
docker-compose build && docker-compose up --renew-anon-volumes
```

Then visit the 3 instances:
- [localhost:4000](http://localhost:4000)
- [localhost:4001](http://localhost:4001)
- [localhost:4002](http://localhost:4002)

and the dashboard: [http://localhost:3000](http://localhost:3000). The login
and password are bot *admin*. Then click on `http_cache dashboard`.

## Tsung stress test

Install Tsung, and type in the shell:

```shell
tsung -f load-testing.xml start
```
