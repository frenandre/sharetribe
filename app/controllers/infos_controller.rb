class InfosController < ApplicationController

  #Allow infos to be viewed before email confirmation
  skip_before_action :cannot_access_without_confirmation

  def about
    @selected_tribe_navi_tab = "about"
    @selected_left_navi_link = "about"
  end

  def how_to_use
    @selected_tribe_navi_tab = "about"
    @selected_left_navi_link = "how_to_use"
    content = if @community_customization && !@community_customization.how_to_use_page_content.nil?
      @community_customization.how_to_use_page_content.html_safe
    else
      MarketplaceService.how_to_use_page_default_content(I18n.locale, @current_community.name(I18n.locale))
    end
    render locals: { how_to_use_content: content }
  end

  def terms
    @selected_tribe_navi_tab = "about"
    @selected_left_navi_link = "terms"
  end

  def privacy
    @selected_tribe_navi_tab = "about"
    @selected_left_navi_link = "privacy"
  end

  def legal_notice
    @selected_tribe_navi_tab = "about"
    @selected_left_navi_link = "legal_notice"
    content = if @community_customization && !@community_customization.legal_notice_page_content.nil?
      @community_customization.legal_notice_page_content.html_safe
    else
      " "
    end
    render locals: { legal_notice_page_content: content }
  end

  def cookies
    @selected_tribe_navi_tab = "about"
    @selected_left_navi_link = "cookies"
    content = if @community_customization && !@community_customization.cookies_page_content.nil?
      @community_customization.cookies_page_content.html_safe
    else
      " "
    end
    render locals: { cookies_page_content: content }
  end

  private

  def how_to_use_content?
    Maybe(@community_customization).map { |customization| !customization.how_to_use_page_content.nil? }
  end
end
