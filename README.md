## http_auth_request_module prototype

Validating that the `http_auth_request_module_prototype` does what we need it to do.

### nginx Devel on OSX

Need to install nginx devel because the http_auth_request_module is 1.5.4+ and stable is 1.4.x.

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
