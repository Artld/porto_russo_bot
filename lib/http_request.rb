require 'faraday'

class HttpRequest
  def self.get url
    begin
      response = Faraday.get url
    rescue Faraday::Error::ConnectionFailed
      raise ArgumentError, 'bad url, connection failed'
    end
    status = response.status.to_i
    raise ArgumentError, "bad server response #{status}" if status >= 400
    response.body
  end
end
