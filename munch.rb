require 'sinatra/base'

class Munch < Sinatra::Base

  get '/' do
    halt "Welcome to Munch"
  end

end