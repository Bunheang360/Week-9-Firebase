import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';
import '../../../model/artist/artist.dart';

class ArtistRepositoryFirebase extends ArtistRepository {
  final Uri artistUri = Uri.https('w9-database-4ff73-default-rtdb.asia-southeast1.firebasedatabase.app', '/artists.json');

  @override
  Future<List<Artist>> fetchArtists() async {
    final http.Response response = await http.get(artistUri);
    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> artistJson = json.decode(response.body);
      List<Artist> result = [];

      for (var iterable in artistJson.entries) {
        Map<String, dynamic> values = iterable.value;
        String artistId = iterable.key;
        result.add(ArtistDto.fromJson(artistId, values));
      }
      
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

}