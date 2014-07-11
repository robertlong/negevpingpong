class Game < ActiveRecord::Base
  belongs_to :player1, class_name: "Player"
  belongs_to :player2, class_name: "Player"

  validates :p1score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :p2score, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
