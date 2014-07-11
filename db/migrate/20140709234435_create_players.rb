class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :rating, default: 1000
      t.string :name
      t.integer :wins, default: 0
      t.integer :losses, default: 0

      t.timestamps
    end
  end
end
