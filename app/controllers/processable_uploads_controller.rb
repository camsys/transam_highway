class ProcessableUploadsController < ApplicationController
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Uploads", :processable_uploads_path

  before_action :set_processable_upload, only: [:destroy]

  # GET /processable_uploads
  def index
    @processable_uploads = ProcessableUpload.all
  end

  # POST /processable_uploads
  def create
    @processable_upload = ProcessableUpload.new(processable_upload_params)
    @processable_upload.document.creator = current_user if @processable_upload.document
    
    if @processable_upload.save
      redirect_to processable_uploads_path, notice: 'File was successfully uploaded.'
    else
      count = view_context.pluralize(@processable_upload.errors.count, 'error')
      errors = @processable_upload.errors.full_messages.join(', ')
      msg = "#{count} prevented the file from being uploaded: #{errors}"
      redirect_to processable_uploads_path, alert: msg
    end
  end

  # DELETE /processable_uploads/1
  def destroy
    @processable_upload.destroy
    redirect_to processable_uploads_url, notice: 'Processable upload was successfully destroyed.'
  end

  # GET /processable_uploads/1/process
  def process_file
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_processable_upload
      @processable_upload = ProcessableUpload.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def processable_upload_params
      params.require(:processable_upload).permit(ProcessableUpload.allowable_params)
    end
end
