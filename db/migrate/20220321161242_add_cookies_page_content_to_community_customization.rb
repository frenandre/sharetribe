class AddCookiesPageContentToCommunityCustomization < ActiveRecord::Migration[5.2]
  def change
    add_column :community_customizations, :cookies_page_content, :mediumtext
  end
end
