require 'sinatra/base'

class Auth < Sinatra::Base
  get '/auth' do
    if request.query_string == "id=secret"
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
