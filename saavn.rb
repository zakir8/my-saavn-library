=begin
 * This class has all the version 4 Saavn mobile API calls that can be used in many different ways
 * Saavn API always returns status code 200 even if the response has an error message, which is inconvienient
=end
require 'net/http'
require 'json'

class Saavn
    # Login should get the cookie back and should use in subsequent calls
    # RETURNS cookie
    def login(user_name, password)
        params = {
            :__call => "user.login",
            :_format => "json",
            :_marker => "false",
            :api_version => 4,
        }

        uri = URI(base_url)
        uri.query = URI.encode_www_form(params)
        response = Net::HTTP.post_form(uri, "username" => user_name, "password" => password)
        parsed_body = JSON.parse(response.body)

        if parsed_body.dig("data", "email")
            #removes annoying empty spaces from the response
            @cookie = response["set-cookie"].split(", ").detect do |cookie|
                if cookie.include?("I=")
                    cookie
                end
            end
        else
            raise ArgumentError.new("Couldn't get your library information. Make sure you entered your login information correctly")
        end
    end

    # this function needs a cookie in order to get user's library
    def get_library
        raise "No cookie. Please call login first" if self.instance_variable.get(:@cookie).nil?

        params = {
            :__call => "library.getAll",
            :_format => "json",
            :_marker => "false",
            :api_version => 4,
            :ctx => "iphoneapp"
        }

        uri = URI(base_url)
        uri.query = URI.encode_www_form(params)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        # request
        request = Net::HTTP::Get.new(uri)
        request["Cookie"] = @cookie
        response = http.request(request)

        if response.code == "200"
            #removes annoying empty spaces from the response
            JSON.parse(response.body.gsub("\n", ""))
        else
            raise "Couldn't get your library information. Make sure you entered your information correctly"
        end
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
        response = Net::HTTP.get_response(uri)
        if response.code == "200"
            # removes the annoying empty spaces from the response
            JSON.parse(response.body.gsub("\n", ""))
        else
            raise "Couldn't get the song information for id's: #{song_ids.join(", ")}"
        end
    end

    # not sure how this could be used, but I will have it for now. the endpoints exists on saavn
    def get_launch_data
        #TODO
    end

    # not sure how this could be used, but I will have it for now. the endpoints exists on saavn
    def get_social_data
        #TODO
    end

    private
        def base_url
            "https://www.saavn.com/api.php"
        end

        def to_param(hsh)
            hsh.inject("") { |glbl,(k,v)| glbl += "&#{k}=#{v}&" }
        end
        
end
