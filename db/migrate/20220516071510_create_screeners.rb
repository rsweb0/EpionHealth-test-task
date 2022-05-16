class CreateScreeners < ActiveRecord::Migration[6.1]
  def change
    create_table :screeners do |t|
      t.integer :check_in_id
      t.timestamps
    end
  end
end
