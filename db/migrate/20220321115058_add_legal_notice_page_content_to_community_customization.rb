class AddLegalNoticePageContentToCommunityCustomization < ActiveRecord::Migration[5.2]
  def change
    add_column :community_customizations, :legal_notice_page_content, :mediumtext
  end
end
