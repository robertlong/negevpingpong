class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :player1_id
      t.integer :p1score
      t.integer :player2_id
      t.string :p2score
      t.integer :player_id

      t.timestamps
    end
  end
end
