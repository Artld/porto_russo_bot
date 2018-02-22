require 'google_drive'
require 'json'

# http://badrit.com/blog/2011/12/25/free-google-translate-api-v2
class GTranslation
  SECRETS = Rails.application.secrets

  def self.init
    # File with google configuration is dinamically generated from variable
    File.open(SECRETS.g_config_file, 'w') { |f| f.write(SECRETS.g_config_var.to_json.to_s) }
    # Then google_drive gem used this file to create session
    session = GoogleDrive::Session.from_config(SECRETS.g_config_file)
    # First worksheet of http://spreadsheets.google.com/ccc?key=...
    @@ws = session.spreadsheet_by_key(SECRETS.spreadsheet_key).worksheets[0]
    @@row = 0
  end

  def self.call(text, lang1, lang2)
    row = next_row
    # call my js script from spreadsheet
    @@ws[row, 1] = "=gTranslate(\"#{text}\", \"#{lang1}\", \"#{lang2}\")"
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
