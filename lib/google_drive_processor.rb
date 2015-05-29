require "google_drive"

class GoogleDriveProcessor

  def initialize(document, document_state)
    @document = document
    @original_state = document_state
  end

  def work
    local_copy = Tempfile.new(@document.upload_file_name)
    converted_copy = Tempfile.new("#{@document.upload_file_name}.html")
    uuid_name = File.basename(local_copy.path) + @document.upload_file_name

    session = create_session

    @document.upload.copy_to_local_file(:original, local_copy.path)
    session.upload_from_file(local_copy.path, uuid_name, :convert => true)

    file = session.file_by_title(uuid_name)
    file.download_to_file(converted_copy.path, :content_type => "text/html")

    unprocessed = File.read(converted_copy.path)
    complete = Nokogiri::HTML(unprocessed)
    # body = complete.css("body")
    # body_contents = complete.css("body").inner_html

    @document.text = complete.css("body").inner_html
    @document.processed_at = DateTime.now
    @document.state = @original_state
    @document.save
  end

  private

  def create_session
=begin
    # NOTE: google_drive update to 1.0.0 
    # requires use of Oauth here. For now, Gemfile
    # forces old version of google_drive
    client = Google::APIClient.new
    auth = client.authorization
    auth.client_id = "YOUR CLIENT ID"
    auth.client_secret = "YOUR CLIENT SECRET"
    auth.scope = [
        "https://www.googleapis.com/auth/drive",
        "https://spreadsheets.google.com/feeds/"
    ]
    auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"
    print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
    print("2. Enter the authorization code shown in the page: ")
    auth.code = $stdin.gets.chomp
    auth.fetch_access_token!
    access_token = auth.access_token
   
    # Creates a session.
    session = GoogleDrive.login_with_oauth(access_token)

    return session
=end
    GoogleDrive.login(ENV['GOOGLE_USER'], ENV['GOOGLE_PASS'])
  end
end
