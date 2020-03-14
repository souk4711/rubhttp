# frozen_string_literal: true

require 'sinatra/base'

class App < Sinatra::Base
  head '/book' do
    [204, {}, '']
  end

  get '/book' do
    [200, {}, '{"id":1,"name":"alpha"}']
  end

  post '/book' do
    [201, {}, '{"id":1,"name":"alpha"}']
  end

  put '/book' do
    [200, {}, '{"id":1,"name":"beta"}']
  end

  delete '/book' do
    [204, {}, '']
  end

  patch '/book' do
    [200, {}, '{"id":1,"name":"beta"}']
  end

  get '/params' do
    if params['foo'] == 'bar'
      'params-foobar'
    else
      ''
    end
  end

  post '/form' do
    if request.form_data? && params['foo'] == 'bar'
      'form-foobar'
    else
      ''
    end
  end

  post '/json' do
    if request.body.read == '{"foo":"bar"}'
      'json-foobar'
    else
      ''
    end
  end

  run! if app_file == $PROGRAM_NAME
end
