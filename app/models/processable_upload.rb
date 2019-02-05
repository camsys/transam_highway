class ProcessableUpload < ApplicationRecord
  # Callbacks
  after_initialize  :set_defaults

  belongs_to :file_status_type
  belongs_to :delayed_job

  has_one :document, :as => :documentable, dependent: :destroy
  accepts_nested_attributes_for :document

  FORM_PARAMS = [
    :class_name,
    {document_attributes: Document.allowable_params}
  ]

  def self.allowable_params
    FORM_PARAMS
  end

  def notes
    document&.description
  end

  protected

  def set_defaults
    self.file_status_type ||= FileStatusType.find_by_name('Unprocessed')
  end
end
