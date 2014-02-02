require 'sinatra'
require 'sinatra/activerecord'
require_relative 'config/database'

Dir[File.join('models', "*.rb")].each {|file| require_relative file }

class Munch < Sinatra::Base

  # to=447860033041&from=441234567890&content=Hello+World&msg_id=AB_12345

  get '/' do
    # halt "Welcome to Munch"
    halt "Welcome to Munch"
  end

  post '/order' do
    # Ensure we have the correct params
    # user_id
    # choice

    # 1. Get the from address
    from = params[:from]
    content = params[:content]


    if from.nil? or content.nil?
      halt 412, { "error" => "You must supply the correct data to the server." }, ""
    end

    fix_number(from)

    # Ok we have the correct information to continue, save the data for now.
    user = User.where(mobile: from).first

    if user.nil?
      puts "> I don't know how to deal with this yet. Line: #{__LINE__}"
      halt 500, {"warning" => "Developer has not yet implemented this."}, ""
    end

    # Has something similar to the content been added today?
    order = Order.all(:conditions =>
      ["choice like ? AND DATE(created_at) >= DATE(?)", "%#{content}%", Time.now])

    unless order.empty?
      # Send the cheeky monkey a message and tell them they have made their choice for today
      halt 200, "The order #{content} has already been placed today!"
    end

    order = Order.new(users_id: user.id, choice: content)

    if order.save
      # Success
      halt 201, {"success" => "Success the order has been placed"}, ""
    end


  end

  get '/orders' do
    content_type :json
    orders = Order.all
    orders.to_json
  end

  get '/users' do
    content_type :json
    users = User.all
    users.to_json
  end

  get '/seed/:name/:number' do |name, number|
    puts "Seeding..."
    User.create!(username: name, mobile: number)
    puts "Seeding complete..."
  end

  def fix_number(number)
    number.sub! '44', '0'
  end

end