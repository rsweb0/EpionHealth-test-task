class AddPhqLevelToScreeners < ActiveRecord::Migration[6.1]
  def change
    add_column :screeners, :phq_level, :integer, default: 1
  end
end
