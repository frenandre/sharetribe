class CreateTelegramBots < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_bots, id: :integer do |t|
      t.string :api_secret_key
      t.integer :community_id

      t.timestamps
    end
  end
end
