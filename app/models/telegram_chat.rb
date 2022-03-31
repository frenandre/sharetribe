# == Schema Information
#
# Table name: telegram_chats
#
#  id              :integer          not null, primary key
#  chat_id         :string(255)
#  locale          :string(255)
#  telegram_bot_id :integer
#  refreshed_at    :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class TelegramChat < ApplicationRecord
    belongs_to :telegram_bot
end
