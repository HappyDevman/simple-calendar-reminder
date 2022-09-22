class CreateReminders < ActiveRecord::Migration[6.1]
  def change
    create_table :reminders do |t|
      t.datetime :datetime, null: false
      t.string :message, null: false
      t.string :color, default: '#FFFFFF'
      t.timestamps
    end
  end
end
