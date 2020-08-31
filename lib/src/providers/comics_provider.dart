import 'dart:async';
import 'dart:convert';

import 'package:comicbook/src/models/comic_model.dart';
import 'package:http/http.dart' as http;

class ComicsProvider{
  String _apikey = '56a0dd87fa43336421f2b47a269e392af154e13e';
  String _url    = 'comicvine.gamespot.com';
  String _format  = 'json';
  String _limit   = '20';
  int _offset = -20;
  bool _loading = false;

  List<Comic> _comics = new List();

  final _comicsStreamController = StreamController<List<Comic>>.broadcast();

  Function(List<Comic>) get comicsSink => _comicsStreamController.sink.add;

  Stream<List<Comic>>  get comicsStream => _comicsStreamController.stream;

  void disposeStreams(){
    _comicsStreamController?.close();
  }

  Future<List<Comic>> getIssues() async{

    if (_loading) return [];

    _loading = true;

    _offset += 20;
    final url = Uri.https(_url, 'api/issues',{
      'api_key' : _apikey,
      'format'  : _format,
      'limit'   : _limit,
      'offset'  : _offset.toString()
    });

    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final comicsResponse = new Comics.fromJsonList(decodedData['results']);
    _comics.addAll(comicsResponse.comics);
    comicsSink(_comics);
    _loading = false;
    return comicsResponse.comics;
  }

  Future<List<ComicInfoDetail>> getComicInfo(String detailUrl) async{
    final url = Uri.parse('$detailUrl?api_key=$_apikey&format=$_format');
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final info = new ComicInfo.fromJson(decodedData['results']);
    return info.itemsInfo;
  }

  Future<String> getInfoImage(String infoUrl) async{
    final url = Uri.parse('$infoUrl?api_key=$_apikey&format=$_format');
    final response = await http.get(url);
    final decodedData = json.decode(response.body)['results'];
    Map<String,dynamic> images = decodedData['image'];
    return images['icon_url'];
  }
}