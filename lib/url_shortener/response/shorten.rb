module UrlShortener
  
  # Provides methods to easily access data from the response returned by bitly when shortening a url.
  # Can return multiple or single short urls
  # e.g. bitly response
  # <bitly>
  #   <errorCode>0</errorCode>
  #   <errorMessage/>
  #   <results>
  #     <nodeKeyVal>
  #       <userHash>15DlK</userHash>
  #       <shortKeywordUrl/>
  #       <hash>31IqMl</hash>
  #       <nodeKey>http://cnn.com</nodeKey>
  #       <shortUrl>http://bit.ly/15DlK</shortUrl>
  #     </nodeKeyVal>
  #   </results>
  #   <statusCode>OK</statusCode>
  # </bitly>
  
  class Response::Shorten < UrlShortener::Response
    
    def initialize(response)
      super
    end
    
    def urls
      raise_if_no_result
      return result['nodeKeyVal']['shortUrl'] unless result['nodeKeyVal'].is_a?(Array)
      result['nodeKeyVal'].collect{|res| res['shortUrl']}
    end
    
    def urls_with_long_url_keys
      raise_if_no_result
      return_single_or_mutiple_hash_values('shortUrl')
    end
    
    def hashes
      raise_if_no_result
      return result['nodeKeyVal']['hash'] unless result['nodeKeyVal'].is_a?(Array)
      result['nodeKeyVal'].collect{|res| res['hash']}
    end
    
    alias :hash :hashes
    
    def hashes_with_long_url_keys
      raise_if_no_result
      return_single_or_mutiple_hash_values('hash')
    end
    
    private
    
    def return_single_or_mutiple_hash_values(value)
      return long_url_with_result(value) unless result['nodeKeyVal'].is_a?(Array)
      return array_of_long_url_with_result(value)
    end
    
    def long_url_with_result(value)
      hash = {}
      hash[result['nodeKeyVal']['nodeKey']] = result['nodeKeyVal'][value]
      return hash
    end
    
    def array_of_long_url_with_result(value)
      hash = {}
      result['nodeKeyVal'].collect{|res| hash[res['nodeKey']] = res[value]}
      return hash
    end
    
    def raise_if_no_result
      if result.nil? || result['nodeKeyVal'].nil?
        raise UrlShortener::NoResult, "Empty Result set."
      end
    end
    
    def base_element
      attributes.nodeKeyVal
    end
    
  end
end