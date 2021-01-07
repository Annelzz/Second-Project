class CreateCards < ActiveRecord::Migration[5.1]
    def up
      create_table :cards do |t|
        t.string :name
      end
    end
  
    def down
      drop_table :cards
    end
end
