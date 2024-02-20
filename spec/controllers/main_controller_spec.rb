require 'rails_helper'

RSpec.describe MainController, type: :controller do
  let(:main_controller) { described_class.new }
  describe '#handle_file_upload' do
    context 'given a txt file' do
      let(:txt_file_path) { Rails.root.join('spec/fixtures/txt/test.txt') }
      let(:uploaded_file) { Rack::Test::UploadedFile.new(txt_file_path, 'text/plain') }

      it 'correctly parse the contents data' do
        result = main_controller.handle_file_upload(uploaded_file)
        expect(result).to eq('HELLOWORLD'.encode('ascii-8bit'))
      end
    end

    context 'given a jpg file' do
      let(:img_file_path) { Rails.root.join('spec/fixtures/image/test_img_1.jpg') }
      let(:uploaded_file) { Rack::Test::UploadedFile.new(img_file_path, 'image/jpeg') }

      it 'correctly parse the contents data as ascii' do
        result = main_controller.handle_file_upload(uploaded_file)
        expect(result).not_to be_nil
      end
    end
  end
end