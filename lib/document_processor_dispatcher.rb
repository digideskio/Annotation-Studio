class DocumentProcessorDispatcher
  def self.processor_for(mime_type)
    if Rails.application.config.use_fake_document_processor == true
      return ProcessorFake
    end

    if ['application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'].include?(mime_type)
      GoogleDriveProcessor
    elsif mime_type == 'application/pdf'
      PdfProcessor
    else
      NullProcessor
    end
  end
end
