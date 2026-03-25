import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../../model/artist_song/artist_song.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;
  final PlayerState playerState;

  AsyncValue<List<ArtistSong>> artistSongsValue = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.playerState,
    required this.artistRepository,
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchArtistsWithSongs();
  }

  Future<void> fetchArtistsWithSongs() async {
    artistSongsValue = AsyncValue.loading();
    notifyListeners();
    try {
      List<Song> songs = await songRepository.fetchSongs();
      List<Artist> artists = await artistRepository.fetchArtists();

      final artistMap = {for (var artist in artists) artist.id: artist};

      final result = songs.map((song) {
        final artist = artistMap[song.artistId];
        return ArtistSong(song: song, artist: artist!);
      }).toList();
      artistSongsValue = AsyncValue.success(result);
    } catch (e) {
      artistSongsValue = AsyncValue.error(e);
    }

    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
