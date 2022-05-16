class CreateResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :responses do |t|
      t.integer :screener_id
      t.string :question
      t.integer :answer
      t.timestamps
    end
  end
end
