# == Schema Information
#
# Table name: export_task_results
#
#  id                :integer          not null, primary key
#  status            :string(255)
#  token             :string(255)
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ExportTaskResult < ApplicationRecord
  attr_accessor :original_filename, :original_extname

  PAPERCLIP_OPTIONS = 
    if (APP_CONFIG.s3_bucket_name && APP_CONFIG.aws_access_key_id && APP_CONFIG.aws_secret_access_key)
      {
        path: "file-exports/:class/:attachment/:id/:filename",
        s3_permissions: :private,
        s3_headers: lambda { |record|
          {
            'Content-Type' => "text/#{record.original_extname}",
            'Content-Disposition' => "attachment; filename=#{record.original_filename}"
          }
        }
      }
    else
      {
        path: ":rails_root/public/system/:class/:attachment/:id/:filename",
        url: "/system/:class/:attachment/:id/:filename",
        validate_media_type: false
      }
    end

  has_attached_file :file, PAPERCLIP_OPTIONS

  do_not_validate_attachment_file_type :file

  STATUSES = ['pending', 'started', 'finished']
  AWS_S3_URL_EXPIRES_SECONDS = 10

  before_create :set_token_and_status

  def set_token_and_status
    self.token  = SecureRandom.urlsafe_base64
    self.status = 'pending'
  end
end
