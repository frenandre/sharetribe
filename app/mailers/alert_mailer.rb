class AlertMailer < ActionMailer::Base
  include MailUtils

  # Enable use of method to_date.
  require 'active_support/core_ext'

  require "truncate_html"
  helper :markdown

  default :from => APP_CONFIG.sharetribe_mail_from_address
  layout 'email'

  add_template_helper(EmailTemplateHelper)

  def alerts_abuse(listing, message, locale, sender)
    set_up_layout_variables(nil, listing.community)
    with_locale(locale, listing.community.locales.map(&:to_sym), listing.community.id) do
      subject = t("alerts.abuse_message")
      mail(:to => listing.community.admin_emails.join(","),
           :from => community_specific_sender(listing.community),
           :subject => subject,
           :reply_to => sender.confirmed_notification_emails_to) do |format|
             format.html {
               render v2_template(listing.community.id, 'alerts_abuse'),
                 layout: v2_layout(listing.community.id),
                 locals: {
                   sender: sender,
                   sender_url: person_url(@url_params.merge(username: sender.username)),
                   listing: listing,
                   message: message,
                   listing_url: listing_url(@url_params.merge(id: listing.id))
                }
             }
      end
    end
  end

end
