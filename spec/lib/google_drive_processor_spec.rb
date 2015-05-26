require 'spec_helper'

describe GoogleDriveProcessor do

  pending "creates temp files before processing" do
    session = double('session').as_null_object
    drive = allow(GoogleDrive).to receive(:login).and_return(session)
    file = Tempfile.new('foo')

    expect(Tempfile).to receive(:new).exactly(3).times.and_return(file)

    upload_file = File.open('spec/support/example_files/example.docx')

    document = create(:document, upload: upload_file, text: nil)

    processor = GoogleDriveProcessor.new(document)
    processor.work
  end

end
