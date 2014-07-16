class GamesController < ApplicationController
  def index
    @games = Game.all.order("created_at desc")
  end

  def new
    @game = Game.new
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    p1 = Player.find(params[:game][:player1])
    p2 = Player.find(params[:game][:player2])
    @game = Game.find(params[:id])
    @game.player1 = p1
    @game.player2 = p2

    if @game.update(params[:game].permit(:p1score, :p2score))
      Player.rerank
      redirect_to @game
    else
      render 'edit'
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    Player.rerank

    redirect_to games_path
  end

  def create
    p1 = Player.find(params[:game][:player1])
    p2 = Player.find(params[:game][:player2])
    @game = Game.new(params[:game].permit(:p1score, :p2score))
    @game.player1 = p1
    @game.player2 = p2

    if @game.save
      p1score = params[:game][:p1score].to_i
      p2score = params[:game][:p2score].to_i

      p1_elo = Elo::Player.new(:games_played => p1.games.count, :rating => p1.rating)
      p2_elo = Elo::Player.new(:games_played => p2.games.count, :rating => p2.rating)

      if p1score > p2score
        p1.wins += 1
        p2.losses += 1

        p1_elo.wins_from(p2_elo)
      elsif p2score > p1score
        p2.wins += 1
        p1.losses += 1

        p2_elo.wins_from(p1_elo)
      end
      p1.rating = p1_elo.rating
      p2.rating = p2_elo.rating
      p1.save
      p2.save
      redirect_to @game
    else
      render 'new'
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  private
    def game_params
      params.require(:game).permit(:player1, :p1score, :player2, :p2score)
    end
end
