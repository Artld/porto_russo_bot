require 'google_drive'
require 'json'

# http://badrit.com/blog/2011/12/25/free-google-translate-api-v2
class GTranslation
  def self.init
    # $logger = Logger.new(STDOUT)
    File.open('./config/g_drive_config.json', 'w') { |f| f.write(Rails.application.secrets.g_config_var.to_json.to_s) }
    # Logs in
    session = GoogleDrive::Session.from_config('./config/g_drive_config.json')
    # First worksheet of http://spreadsheets.google.com/ccc?key=...
    @@ws = session.spreadsheet_by_key('15DD8yQCyRyKIg0BFTFQ9i1SKw2Q-lc9GH32hw8PKyw4').worksheets[0]
    @@row = 0
  end

  def self.call text, lang_1, lang_2
    row = next_row
    # call my script from spreadsheet
    @@ws[row, 1] = "=gTranslate(\"#{text}\", \"#{lang_1}\", \"#{lang_2}\")"
    @@ws.save
    # Reloads the worksheet to get my changes effect
    @@ws.reload
    @@ws[row, 1]
  end

  private_class_method def self.next_row
    if @@row > 30
      @@row = 1
    else
      @@row += 1
    end
    @@row
  end
end
