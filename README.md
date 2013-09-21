## http_auth_request_module prototype

Validating that the `http_auth_request_module_prototype` does what we need it to do.

### nginx Devel on OSX

Need to install nginx devel because the http_auth_request_module is 1.5.4+ and stable is 1.4.x. You may need to `brew remove nginx` if you've previously installed it.

```sh
$ brew edit nginx
```

in the array begun on line 58 (`args = [`) add new argument:

```ruby
  "--with-http_auth_request_module"
```

Don't forget to add the `,` on the line above (`"--with-http_gzip_static_module"`).

Now build:

```sh
$ brew install nginx --devel
```

The `nginx.conf` has several hard coded paths in it; update those paths with the path to this repository directory and the `./content` directory as applicable.

### Sinatra auth app

You'll need to rvm accept the `.rvmrc` configuration and then run `bundle` to install
all of the dependencies (sinatra and shotgun).

### Running

Executing the `./start` script will stop nginx and restart it with the `nginx.conf` found
in this repository. Then it will use `shotgun` to launch the Sinatra application.

nginx runs on port 8888 and shotgun fires up Sinatra on port 9393.

Requests to [localhost:8888?id=anything_but_secret](http://localhost:8888?auth=ninja) should result in failure due to HTTP 401 Unauthorized. Requests to [localhost:8888?id=secret](http://localhost:8888?id=secret) should result in success, where authentication occurs via nginx passing through to Sinatra for a HTTP status 200 (based on the `id` query string parameter being the value `secret`). Any other request should result in another HTTP error status code.

A successful 200 HTTP request should cause your browser to display an excellent image.

You can validate the Sinatra behavior by using `curl -v "localhost:9393/url"`.

### Stopping

Use `Ctrl+C` to stop shotgun. nginx can be stopped by running `nginx -s stop`.

### How This Works

nginx is configured to forward all requests to `/` to `/auth` via proxy and to include a custom header `X-Original-URI` which Sinatra string matches on to determine whether it should return an HTTP 200 status or some other status code. When nginx receives a HTTP 200 it continues the request pipeline as normal; when it receives a 4xx status it replies with a HTTP 401 Unauthorized, and any other status code results in a HTTP 500.
