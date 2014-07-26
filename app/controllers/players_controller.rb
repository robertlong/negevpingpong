class PlayersController < ApplicationController
  def index
    @players = Player.all.order("rating desc")
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(params[:player].permit(:name))

    if @player.save
      redirect_to action: 'index'
    else
      render 'new'
    end
  end

  def show
    @player = Player.find(params[:id])
    @games = @player.games.sort_by { |p| p.created_at }.reverse
  end
end
