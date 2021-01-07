class CreateDecks < ActiveRecord::Migration[5.1]
    def up
      create_table :decks do |t|
        t.string :name
        t.string :cards
      end
    end
    
    def down
      drop_table :decks
    end
end
