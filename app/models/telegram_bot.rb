# == Schema Information
#
# Table name: telegram_bots
#
#  id             :integer          not null, primary key
#  api_secret_key :string(255)
#  community_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class TelegramBot < ApplicationRecord
    belongs_to :community
end
