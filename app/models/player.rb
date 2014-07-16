class Player < ActiveRecord::Base
  has_many :games
  validates :name, presence: true, uniqueness: true

  def games
    Game.where("player1_id = ? OR player2_id = ?", id, id)
  end

  def self.rerank
    Player.all.each do |p|
      p.wins = 0
      p.losses = 0
      p.rating = 1000
      p.save
    end

    Game.all.each do |g|
      p1 = g.player1
      p2 = g.player2

      p1_elo = Elo::Player.new(:games_played => p1.wins + p1.losses, :rating => p1.rating)
      p2_elo = Elo::Player.new(:games_played => p2.wins + p2.losses, :rating => p2.rating)

      if g.p1score.to_i > g.p2score.to_i
        p1.wins += 1
        p2.losses += 1

        p1_elo.wins_from(p2_elo)
      elsif g.p2score.to_i > g.p1score.to_i
        p2.wins += 1
        p1.losses += 1

        p2_elo.wins_from(p1_elo)
      end
      p1.rating = p1_elo.rating
      p2.rating = p2_elo.rating
      p1.save
      p2.save
    end
  end
end
