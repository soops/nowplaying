class NowPlaying
	constructor: (@key) ->
        if not @key? then throw new Error "NowPlaying: Please define a valid Last.fm API key."

	getLastPlayed: (user, limit) ->
        # default amount of returned songs to 5
        if not limit? then limit = 5

	    $.getJSON "http://ws.audioscrobbler.com/2.0/?method=user.getRecentTracks&user=#{user}&api_key=#{@key}&limit=#{limit}&format=json&callback=?", (data) ->
            song = data.recenttracks.track[0]

            if song["@arg"].nowPlaying != ""
                lastSongFullSentence = 'I\'m currently listening to ' + '<a class=\'music\' href=\'' + song['url'] + '\'>' + song.name + ' by ' + song.artist['#text'] + '</a>.'
            else
                lastSongFullSentence = 'The last song I listened to was ' + '<a class=\'music\' href=\'' + song['url'] + '\'>' + song.name + ' by ' + song.artist['#text'] + '</a>.'

            {
                # array of songs
                json: data.recenttracks

                # last song
                last: {
                    # full json data
                    json: data.recenttracks.track[0]

                    album: data.recenttracks[0].album["#text"] # album name
                    artist: data.recenttracks[0].artist["#text"] # artist name
                    song: data.recenttracks[0].name # song name
                    sentence: lastSongFullSentence, # full sentence
                    time: new Date(data.recenttracks[0].time["uts"]) # time played

                    # album art
                    image: {
                        small: data.recenttracks[0].image[0]["#text"]
                        medium: data.recenttracks[0].image[1]["#text"]
                        large: data.recenttracks[0].image[2]["#text"]
                        extraLarge: data.recenttracks[0].image[3]["#text"]
                    }
                }
            }
            