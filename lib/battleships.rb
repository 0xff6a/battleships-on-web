require 'sinatra/base'
require_relative 'game'

class BattleShips < Sinatra::Base

  GAME = Game.new

  enable :sessions
  set :session_secret, "My session secret"
  set :views, Proc.new{ File.join(root, '..', 'views') }

  get '/' do
    session[:player] = ""
    session[:deployed_ships] = 0
    erb :index
  end

  get '/new_game' do
    erb :new_game
  end

  post '/new_game' do
    @name, session[:player] = params[:player], params[:player]
    redirect '/new_game' if @name.empty?
    GAME.add(Player.new(params[:player]))
    redirect "/launch_game/#{session[:player]}" if GAME.start?
    redirect '/session_full' if GAME.player_count > 2
    redirect '/waiting'
  end

  get '/session_full' do
    erb :session_full
  end


  get '/waiting' do
    redirect "/launch_game/#{session[:player]}" if GAME.start?
    erb :waiting
  end

  get '/launch_game/:player' do |player|
    session[:counter] = 0
    @deploying_player = player
    @target_grid = GAME.player(player).grid
    @current_ship = GAME.player(player).ships[session[:counter]]
    session[:counter] +=1
    @counter = session[:counter]
    erb :launch_game
  end

  post '/launch_game/:player/:n' do |player, n|
    @deploying_player = player
    ship_to_deploy = GAME.player(player).ships[n.to_i-1]
    coords = GAME.generate_coordinates(params[:ship_start].to_sym, params[:ship_end].to_sym)
    GAME.player(player).deploy_ship_to(coords, ship_to_deploy)
    redirect "/launch_game/#{player}/waiting" if session[:counter] == 5
    @target_grid = GAME.player(player).grid
    @current_ship = GAME.player(player).ships[n.to_i]
    session[:counter] +=1
    @counter = session[:counter]
    erb :launch_game
  end

  get '/launch_game/:player/waiting' do |player|
    redirect "/play_game/#{player}" if GAME.ships_deployed?
    erb :waiting
  end

  get '/play_game/:player' do |player|
    @attacking_player = "ME"
    @tracking_grid = GAME.player(player).grid
    @message = "HIT"
    erb :play_game
  end

  post '/play_game/:player/' do |player|
    @attacking_player = player
    @tracking_grid = GAME.player(player).grid
    @message = "HIT"
    erb :play_game
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end

  
