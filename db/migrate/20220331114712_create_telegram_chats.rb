class CreateTelegramChats < ActiveRecord::Migration[5.2]
  def change
    create_table :telegram_chats, id: :integer do |t|
      t.string :chat_id
      t.string :locale
      t.integer :telegram_bot_id
      t.datetime :refreshed_at

      t.timestamps
    end
  end
end
