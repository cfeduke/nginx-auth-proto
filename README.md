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

The `nginx.conf` has a hard coded path in it; update that path with the path to the
`./content` directory that is a part of this repository.

### Sinatra auth app

You'll need to rvm accept the `.rvmrc` configuration and then run `bundle` to install
all of the dependencies (Sinatra and shotgun).

### Running

Executing the `./start` script will stop nginx and restart it with the `nginx.conf` found
in this repository. Then it will use `shotgun` to launch the Sinatra application.

nginx runs on port 8888 and shotgun fires up Sinatra on port 9393.

Requests to [localhost:8888?auth=anything_but_secret](http://localhost:8888?auth=ninja) should result in failure due to HTTP 401 Unauthorized. Requests to [localhost:8888?auth=secret](http://localhost:8888?auth=secret) should result in success, where authentication occurs via nginx passing through to Sinatra for a HTTP status 200 (based on the `auth` query string parameter being the value `secret`). Any other request should result in another HTTP error status code.

A successful 200 HTTP request should cause your browser to display an excellent image.

You can validate the Sinatra behavior by using `curl -v "localhost:9393/url?query"`.
