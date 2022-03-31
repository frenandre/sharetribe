require 'rest-client'

namespace :sharetribe do
  namespace :telegram do

    @telegram_host = 'https://api.telegram.org'

    def post(listing, host, locale, chat_id, api_secret_key)
      puts "post listing #{listing.id} to telegram"

      text = format_listing_title(listing[:shape_name_tr_key], listing[:title])
      text += "\n\n" + listing.description unless listing.description.nil? || listing.description.empty?
      text += "\n\n" + listing_url(id: listing.id, locale: locale, host: host)

      RestClient.post("#{@telegram_host}/bot#{api_secret_key}/sendMessage", { chat_id: chat_id, text: text, parse_mode: :Markdown })
    end

    def format_listing_title(shape_tr_key, listing_title)
      listing_shape_name = I18n.t(shape_tr_key)
      if listing_shape_name.include?("translation missing")
        listing_title
      else
        "#{listing_shape_name}: #{listing_title}"
      end
    end

    desc "Pulish listings to telegram channels"
    task publish: :environment do
      include MailUtils
      include ListingsHelper
      include Rails.application.routes.url_helpers

      TelegramChat.all().each { |chat|
        date1 = chat.refreshed_at || DateTime.new(2000, 1, 1)
        date2 = DateTime.now - (15.0/(24*60))
        community = chat.telegram_bot.community
        begin
          with_locale(chat.locale, community.locales.map(&:to_sym), community.id) do
            Listing.where('created_at > ? and created_at < ? and community_id = ?', date1, date2, community.id).order(created_at: :asc).each { |listing|
              post listing, community.full_url, chat.locale, chat.chat_id, chat.telegram_bot.api_secret_key
              date1 = listing.created_at
            }
          end
        rescue StandardError => e
          puts e.backtrace
        ensure
          chat.refreshed_at = date1
          chat.save()
        end
      }
    end
  end
end
