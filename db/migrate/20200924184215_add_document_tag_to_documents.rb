class AddDocumentTagToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_reference :documents, :document_tag, foreign_key: true
  end
end
