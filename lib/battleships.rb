require 'sinatra/base'
require_relative 'game'

class BattleShips < Sinatra::Base

  GAME = Game.new

  enable :sessions
  set :session_secret, "My session secret"
  set :views, Proc.new{ File.join(root, '..', 'views') }

  get '/' do
    session[:players] = []
    session[:greeting] = "What's your name?"
    erb :index
  end

  get '/new_game' do
    @greeting = session[:greeting]
    erb :new_game
  end

  post '/new_game' do
    @name = params[:player]
    redirect '/name_input' if @name.empty?
    session[:greeting] = "Welcome #{@name} please enter your opponent"
    
    GAME.add(Player.new(params[:player]))
    redirect "/launch_game/#{GAME.current_player.name}" if GAME.player_count == 2
    redirect '/full' if GAME.player_count > 2
    redirect '/new_game'
  end

  get '/launch_game/:player' do |player|
    session[:counter] = 0
    @deploying_player = player
    @target_grid = GAME.current_player.grid
    @current_ship = GAME.current_player.ships[session[:counter]]
    session[:counter] +=1
    @counter = session[:counter]
    erb :launch_game
    # until session[:game].current_player.ships.empty?
    #   erb :launch_game
    # end
    # ctr +=1
    # redirect 'play_game' if ctr == 2
    #get player to place ships with validation
    #increment counter
    #proceed to play_game once both ships have been placed
  end

  post '/launch_game/:player/:n' do |player, n|
    @deploying_player = GAME.current_player.name
    ship_to_deploy = GAME.current_player.ships[n.to_i-1]
    coords = GAME.generate_coordinates(params[:ship_start].to_sym, params[:ship_end].to_sym)
    GAME.current_player.deploy_ship_to(coords, ship_to_deploy)
    @target_grid = GAME.current_player.grid
    @current_ship = GAME.current_player.ships[n.to_i]
    session[:counter] +=1
    @counter = session[:counter]
    if @counter == 5
          
    erb :launch_game
  end

  # post '/launch_game' do
  #   @game.change_turn
  #   redirect '/launch_game' 
  # end

  post '/play_game' do
    puts params
    "Hi"
    #Loop
    #Prompt the player
    #Display their tracking grid
    #Ask for coordinate (radio buttons?)
    #Return cell message
    #Attack cell if valid
    #end game if victory declared
    #change player
  end

  get '/play_game' do

  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end