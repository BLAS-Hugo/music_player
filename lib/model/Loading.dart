import 'package:http/http.dart';
import 'dart:convert';


class Music {

  final API_KEY = '6991ab6b84803c30ad9b5640b386b03d';
  final URL = 'https://ws.audioscrobbler.com';



  Future<List> getTracks() async{
    Response response = await get(Uri.parse(URL + '/2.0/?method=chart.gettoptracks&api_key=$API_KEY&format=json'));
    Map data = jsonDecode(response.body);
    List tracks = data['tracks']['track'];

    return tracks;
  }





}