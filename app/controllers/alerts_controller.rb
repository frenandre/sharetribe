class AlertsController < ApplicationController

  before_action do |controller|
    controller.ensure_logged_in t("alerts.you_must_log_in_to_send_an_alert")
  end

  def abuse
    listing = Listing.find_by!(id: params[:listing_id], community_id: @current_community.id)
    render locals: {
      listing: listing,
      display_name: PersonViewUtils.person_display_name(listing.author, listing.community)
    }
  end

  def email
    listing = Listing.find_by!(id: params[:listing_id], community_id: @current_community.id)

    MailCarrier.deliver_later(AlertMailer.alerts_abuse(listing, params[:message], params[:locale], @current_user))

    flash[:notice] = t("layouts.notifications.feedback_saved")
    redirect_to listing
  end

 end
