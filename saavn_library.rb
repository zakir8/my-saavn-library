require_relative 'saavn'
require_relative 'csv_file'

ARGV.each_slice(2) do|user, pass|
    user = ARGV[0]
    pass = ARGV[1]

    s = Saavn.new
    s.login(user, pass)
    library = s.get_library

    puts "NOTE: This may take a while depending on your library size."

    all_songs_meta_data = [["Song ID", "Song Name", "Album", "Artist", "Music Composer", "Lyrics", "Label", "Year", "Language", "Actors", "Encrypter Media URL"]]
    library["song"].each do |song_id|
        puts "++++ song_id: #{song_id}"
        song_meta = s.get_songs_details(song_id)

        id = song_meta[song_id]["id"]
        album = song_meta[song_id]["more_info"]["album"]
        title = song_meta[song_id]["title"]
        singers = song_meta[song_id]["more_info"]["artistMap"]["artists"].collect {|x| x["name"] if x["role"] == "singer"}.compact.join(", ")
        music_composers = song_meta[song_id]["more_info"]["artistMap"]["artists"].collect {|x| x["name"] if x["role"] == "music" }.compact.join(", ")
        lyricists = song_meta[song_id]["more_info"]["artistMap"]["artists"].collect {|x| x["name"] if x["role"] == "lyricist" }.compact.join(", ")
        music_label = song_meta[song_id]["more_info"]["label"]
        language = song_meta[song_id]["language"].capitalize
        starring = song_meta[song_id]["more_info"]["artistMap"]["artists"].collect {|x| x["name"] if x["role"] == "starring" }.compact.join(", ")
        encrypted_media_url = song_meta[song_id]["more_info"]["encrypted_media_url"]
        year = song_meta[song_id]["year"]

        all_songs_meta_data << [
            id,
            title,
            album,
            singers,
            music_composers,
            lyricists,
            music_label,
            year,
            language,
            starring,
            encrypted_media_url
        ]

        puts "
            **** Title : #{title}
            **** Album : #{album}
            **** Singer : #{singers}
        "
    end

    puts "Wrapping up!"

    file_name = "saavn_songs_#{user}.csv"
    CSVFile.save!(file_name, all_songs_meta_data)

    puts "Please look in the project for '#{file_name}'"
end