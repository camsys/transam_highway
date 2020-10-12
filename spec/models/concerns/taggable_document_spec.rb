require 'rails_helper'

RSpec.describe TaggableDocument, :type => :model do

  # extensions aren't loaded for tests
  Document.class_eval do
    include TaggableDocument
  end

  let(:test_doc) { create(:document, :documentable => create(:bridge), :document_tag => create(:document_tag)) }

  describe 'associations' do
    it 'has a tag which has a folder' do
      expect(test_doc.document_tag.name).to eq('TAG')
      expect(test_doc.document_tag.document_folder.name).to eq('Folder')
    end
  end

  describe 'update_from_filename' do
    it 'updates original_filename' do
      test_doc.update_from_filename("new_test_file.pdf")
      expect(test_doc.original_filename).to eq("new_test_file.pdf")
    end
    {nil => false, 1 => true, {} => true, '' => false}.each do |val, expected|
      it "returns #{expected} when filename is #{val}" do
        expect(test_doc.update_from_filename(val)).to eq(expected)
      end
    end
  end
end
