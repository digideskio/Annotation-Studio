require 'spec_helper'

describe DocumentProcessor do
  it "should instantiate a document when performing" do
    document = build(:document, id: 100)
    expect(Document).to receive(:find).with(document.id).and_return(document)

    job = described_class.new(document.id, 'a state', 'www')
    job.perform
  end

  it "should use the DocumentProcessorDispatcher to find which processor to use" do
    document = build(:document, id: 100, upload: example_file('example.docx'))
    allow(Document).to receive(:find).with(document.id).and_return(document)

    expect(DocumentProcessorDispatcher).to receive(:processor_for).
      with(document.upload.content_type).
      and_return(NullProcessor)

    job = described_class.new(document.id, 'a state', 'www')
    job.perform
  end

  context 'apartment multitenancy' do
    it 'switches tenants when running a job' do
      Apartment::Tenant.switch!('public')
      document = build(:document, id: 100)
      expect(Document).to receive(:find).with(document.id).and_return(document)

      expect(Apartment::Tenant).to receive(:switch!).with('www')
      expect(Apartment::Tenant).to receive(:switch!).with(Apartment::Tenant.current)

      job = described_class.new(document.id, 'a state', 'www')
      job.perform
    end
  end
end
