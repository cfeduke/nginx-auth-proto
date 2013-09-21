require 'sinatra/base'

class Auth < Sinatra::Base

  set :logging, true

  get '/auth' do
    # nginx's X-Original-URI (from nginx.conf) is mapped to 'HTTP_X_ORIGINAL_URI' in Sinatra
    original_uri = request.env['HTTP_X_ORIGINAL_URI']
    logger.info "original_uri: #{original_uri}"
    if original_uri == "/?id=secret"
      logger.info "successful authentication"
      status 200
      body 'success'
    else
      logger.info "failed authentication"
      status 401
      body 'failure'
    end
  end

  get '*' do
    logger.info "returning error code"
    status 410
  end

  run! if app_file == $0
end
