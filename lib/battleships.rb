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
    @target_grid = own_grid(player)
    @current_ship = nth_ship([session[:counter])
    session[:counter] +=1
    @counter = session[:counter]
    erb :launch_game
  end

  post '/launch_game/:player/:n' do |player, n|
    @deploying_player = player
    ship_to_deploy = nth_ship(n.to_i - 1)
    coords = get_coords(params[:ship_start], params[:ship_end])
    # redirect "/launch_game/#{player}/#{n-1}" unless valid_coordinates_for(ship_to_deploy, GAME.player(player).grid, coords)
    GAME.player(player).deploy_ship_to(coords, ship_to_deploy)

    redirect "/launch_game/#{player}/waiting" if session[:counter] == 5
    
    @target_grid = own_grid(player)
    @current_ship = nth_ship(n)
    
    session[:counter] +=1
    @counter = session[:counter]
    erb :launch_game
  end

  get '/launch_game/:player/waiting' do |player|
    redirect "/play_game/#{player}" if GAME.ships_deployed?
    erb :waiting
  end

  get '/play_game/:player' do |player|
    @attacking_player = player
    @tracking_grid = opponent_grid(player)
    erb :play_game
  end

  post '/play_game/:player/' do |player|
    @message = get_message(player, params[:coordinate])
    shoot_at(params[:coordinate], player)
    redirect "/victory/#{player}" if GAME.end?
    @attacking_player = player
    @tracking_grid = opponent_grid(player)
    erb :play_game
  end

  get '/victory/:player' do |player|
    @winner = player
    erb :victory
  end

  def own_grid(player)
    GAME.player(player).grid
  end

  def opponent_grid(player)
    GAME.opponent(player).grid
  end

  def nth_ship(n)
    GAME.player(player).ships[n.to_i]
  end

  def shoot_at(coordinate, player)
    GAME.player(player).shoot_at(GAME.opponent(player).grid, coordinate.to_sym)
  end

  def get_message(player, coordinates)
    GAME.opponent(player).grid.cell(coordinates.to_sym).message
  end

  def get_coords(ship_start, ship_end)
    GAME.generate_coordinates(ship_start.downcase.to_sym, ship_end.downcase.to_sym)
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end

  
