# require "rubygems"
require 'google_drive'

# http://badrit.com/blog/2011/12/25/free-google-translate-api-v2
class GTranslation
  def self.init
    # Logs in. You can also use OAuth
    $logger = Logger.new(STDOUT)
    $logger.debug 'try to create session'
    session = GoogleDrive::Session.from_config('./config/google_drive_config.json')
    $logger.debug 'session OK'
    # First worksheet of http://spreadsheets.google.com/ccc?key=...
    @@ws = session.spreadsheet_by_key("15DD8yQCyRyKIg0BFTFQ9i1SKw2Q-lc9GH32hw8PKyw4").worksheets[0]
    $logger.debug 'spreadsheet OK'
    @@row = 0
  end

  def self.call text, lang_1, lang_2
    row = next_row
    $logger.debug lang_1
    $logger.debug lang_2
    # call my script from spreadsheet
    @@ws[row,1] = "=gTranslate(\"#{text}\", \"#{lang_1}\", \"#{lang_2}\")"
    @@ws.save
    # Reloads the worksheet to get my changes effect
    @@ws.reload
    @@ws[row,1]  #Esta es una prueba
  end

  private

  def self.next_row
    if @@row > 30
      @@row = 1
    else
      @@row += 1
    end
    @@row
  end
end
