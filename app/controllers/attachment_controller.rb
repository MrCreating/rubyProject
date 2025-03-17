class AttachmentController < ApplicationController
  before_action :require_login

  def create
    file = params[:file]
    return render json: { message: 'No file provided', error: 1 }, status: :bad_request if file.nil?

    file_type = file.content_type.start_with?('image/') ? 'photo' : 'document'

    access_key = SecureRandom.hex(10)

    attachment = Attachment.new(
      user_id: current_user.id,
      access_key: access_key,
      type: file_type
    )

    attachment.file.attach(file)
    if attachment.save
      render json: {
        id: attachment.id,
        owner_id: attachment.user.id,
        access_key: attachment.access_key,
      }, status: :ok
    else
      render json: { error: 1 }, status: :unprocessable_entity
    end
  end

  def show
    attachment_params = params[:attachment]
    attachment = Attachment.find_by_photo(photo: attachment_params)

    return head :not_found if attachment == nil

    redirect_to url_for(attachment.file)
  end
end
