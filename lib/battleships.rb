require 'sinatra/base'
require_relative 'game'
require_relative 'grid'

class BattleShips < Sinatra::Base

  GAME = Game.new

  enable :sessions
  set :session_secret,  "My session secret"
  set :views,           Proc.new{ File.join(root, '..', 'views')  }
  set :public_folder,   Proc.new{ File.join(root, '..', 'public') }

  get '/' do
    session[:player] = ""
    session[:deployed?] = false
    erb :index
  end

  get '/new_game' do
    erb :new_game
  end

  post '/new_game' do
    add_new_player(params[:player])
    redirect "/launch_game/#{session[:player]}/0" if GAME.start?
    redirect '/session_full' if GAME.full?
    redirect '/waiting'
  end

  get '/session_full' do
    erb :session_full
  end

  get '/waiting' do
    redirect "/launch_game/#{session[:player]}/0" if GAME.start? 
    erb :waiting
  end

  get '/launch_game/:player/:n' do |player, n|
    @error = params[:error]
    n = n.to_i
    @deploying_player = player
    @target_grid = own_grid(player)
    @current_ship = nth_ship(n, player)
    @next_ship = n + 1
    erb :launch_game
  end

  post '/launch_game/:player/:n' do |player, n|
    n = n.to_i
    @deploying_player = player
    ship_to_deploy = nth_ship(n.to_i - 1, player)
    coords = get_coords(params[:ship_start], params[:ship_end])
    unless GAME.valid_coordinates_for?(ship_to_deploy, own_grid(player), coords)
      redirect "/launch_game/#{player}/#{n-1}?error=ERROR:%20Bad%20Coordinate" 
    end
    GAME.player(player).deploy_ship_to(coords, ship_to_deploy)
    GAME.status = :deployed if GAME.ships_deployed?
    redirect "/waiting/#{player}" if n == 5
    @target_grid = own_grid(player)
    @current_ship = nth_ship(n, player)
    @next_ship = n + 1
    erb :launch_game
  end

  get '/waiting/:player' do |player|
    redirect "/play_game/#{player}" if time_to_play?(player)
    erb :waiting
  end

  get '/waiting_to_shoot/:player' do |player|
    redirect "/play_game/#{player}" if your_turn?(player)
    redirect "/defeat/#{player}" if GAME.end?
    @message = params[:message]
    erb :waiting
  end

  get '/play_game/:player' do |player|
    @message = params[:message]
    @attacking_player = player
    @tracking_grid = opponent_grid(player)
    @own_grid = own_grid(player)
    erb :play_game
  end

  post '/play_game/:player' do |player|
    message = get_message(player, params[:coordinate]) if GAME.valid_coordinate?(params[:coordinate])
    redirect "/play_game/#{player}?message=#{message}" unless valid_shot?(message, params[:coordinate]) 
    shoot_at(params[:coordinate], player)
    redirect "/victory/#{player}" if GAME.end?
    GAME.change_turn
    redirect "/waiting_to_shoot/#{player}?message=#{message}"
  end

  get '/victory/:player' do |player|
    @winner = player
    erb :victory
  end

  get '/defeat/:player' do |player|
    @loser = player
    erb :defeat
  end

  get '/reset' do
    reset_game
    erb :reset
  end

  def reset_game
    GAME.players = []
    GAME.status = nil
    session[:player] = ""
    session[:deployed?] = false
  end

  def add_new_player(player)
    @name = player
    redirect '/new_game' if @name.empty?
    session[:player] = player.gsub(" ", "_")
    add_player(player.gsub(" ", "_"))
  end

  def time_to_play?(player)
    GAME.status == :deployed && your_turn?(player)
  end

  def add_player(player)
    GAME.add(Player.new(player))
  end

  def valid_shot?(message, coordinate)
    return false if message == "MISFIRE!"
    GAME.valid_coordinate?(coordinate)
  end

  def your_turn?(player)
    GAME.player(player) == GAME.current_player
  end

  def own_grid(player)
    GAME.player(player).grid
  end

  def opponent_grid(player)
    GAME.opponent(player).grid
  end

  def nth_ship(n, player)
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

  
