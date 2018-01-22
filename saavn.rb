=begin
This class has all the version 4 Saavn mobile API calls that can be used in many different ways
=end
require 'net/http'

class Saavn

    # Login should get the cookie back and should use in subsequent calls
    # RETURNS cookie
    def login(user_name, password)

        # @cookie = 
    end

    # not sure how this could be used, but I will have it for now
    def get_launch_data

    end

    def get_library

    end

    # takes an array of song_id's
    def get_songs_details(song_ids)
        params = {
            :__call => "song.getDetails",
            :pids => song_ids.join(","),
            :_format => "json",
            :_marker => "false",
            :api_version => 4
        }

        uri = URI(base_url)
        uri.query = URI.encode_www_form(params)
        request = Net::HTTP.get_reponse(uri)

        response.body
    end

    def base_url
        "http://www.saavn.com/api.php"
    end

    private

    def to_param(hsh)
        str = ""
        hsh.inject("") { |glbl,(k,v)| glbl += "&#{k}=#{v}&" }
    end

end
