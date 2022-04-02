require 'rest-client'

namespace :sharetribe do
  namespace :telegram do

    @telegram_host = 'https://api.telegram.org'

    def post(listing, url, locale, chat_id, api_secret_key)
      puts "post listing #{listing.id} to telegram"

      text = listing.shape_name_tr_key ? "#{t(listing.shape_name_tr_key)}: " : ''
      text += listing.title
      text += "\n#{url}"

      RestClient.post("#{@telegram_host}/bot#{api_secret_key}/sendMessage", { chat_id: chat_id, text: text, parse_mode: :Markdown, disable_notification: true })
      sleep 5
    end

    desc "Pulish listings to telegram channels"
    task publish: :environment do
      include MailUtils
      include ActionView::Helpers::TranslationHelper
      include Rails.application.routes.url_helpers

      TelegramChat.all().each { |chat|
        date1 = chat.refreshed_at || DateTime.new(2000, 1, 1)
        date2 = DateTime.now - (15.0/(24*60))
        community = chat.telegram_bot.community
        begin
          with_locale(chat.locale, community.locales.map(&:to_sym), community.id) do
            where = 'created_at > ? and created_at < ? and community_id = ? and open = 1 and deleted = 0'
            Listing.where(where, date1, date2, community.id).order(created_at: :asc).each { |listing|
              url = listing_url(id: listing.id, locale: chat.locale, host: community.full_url)
              post listing, url, chat.locale, chat.chat_id, chat.telegram_bot.api_secret_key
              date1 = listing.created_at
            }
          end
        rescue StandardError => e
          puts e
        ensure
          chat.refreshed_at = date1
          chat.save()
        end
      }
    end
  end
end
