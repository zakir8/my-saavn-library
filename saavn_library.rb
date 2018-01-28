require_relative 'saavn'
ARGV.each do|info|
    user = ARGV[0]
    pass = ARGV[1]

    # should have functionality to
    # get songs in csv
    # get playlist details in csv
    # get user details

    s = Saavn.new
    s.login(user, pass)
    library = s.get_library


    # songs details should have
    # Name
    # Singers
    # Music composers
    # Lyrics composers
    # Music Label
    # 
    library["song"].each_slice(200) do |song_slice|
        songs_meta = s.get_songs(song_slice)
    end
end