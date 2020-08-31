class Comics{
  List<Comic> comics = new List();
  Comics();
  Comics.fromJsonList(List<dynamic> jsonList){
    if(jsonList==null) return;
    for (var item in jsonList){
      final comic = new Comic.fromJsonMap(item);
      comics.add(comic);   
    }
  }
}

class Comic {
  String apiDetailUrl;
  String dateAdded;
  String issueNumber;
  String name;
  String image;
  String screenImage;
  String id;

  Comic({
    this.apiDetailUrl,
    this.dateAdded,
    this.issueNumber,
    this.name,
    this.image,
    this.screenImage,
    this.id
  });

  Comic.fromJsonMap(Map<String, dynamic> json){
    Map<String,dynamic> images = json['image'];
    Map<String,dynamic> volume = json['volume'];
    if (images['screen_url']==null){
      screenImage = 'https://i.makeagif.com/media/11-04-2015/mfnzwt.gif';
    }else{
      screenImage  = images['screen_url'];
    }
    if (images['small_url']==null){
      image = 'https://i.makeagif.com/media/11-04-2015/mfnzwt.gif';
    }else{
      image = images['small_url'];
    }
    name         = volume['name'];
    apiDetailUrl = json['api_detail_url'];
    dateAdded    = json['date_added'].toString().split(' ')[0];
    issueNumber  = json['issue_number'];
    id           = json['id'].toString();
  }
}

class ComicInfo{
  List<ComicInfoDetail> itemsInfo = new List();

  ComicInfo({
    this.itemsInfo
  });

  ComicInfo.fromJson(Map<String,dynamic> json){
    if(json==null) return;
    List<dynamic> characters = json['character_credits'];
    for (var item in characters){
      final singleInfo = new ComicInfoDetail.fromJsonMap(item,1);
      itemsInfo.add(singleInfo);
    }
    List<dynamic> concepts = json['concept_credits'];
    for (var item in concepts){
      final singleInfo = new ComicInfoDetail.fromJsonMap(item,2);
      itemsInfo.add(singleInfo);
    }
    List<dynamic> location = json['location_credits'];
    for (var item in location){
      final singleInfo = new ComicInfoDetail.fromJsonMap(item,3);
      itemsInfo.add(singleInfo);
    }
  }
}

class ComicInfoDetail{
  String apiDetail;
  String name;
  String image;
  int id;
  int itemClass; // 1-Character 2-Concept 3-Location

  ComicInfoDetail({
    this.apiDetail,
    this.name,
    this.image,
    this.id
  });

  ComicInfoDetail.fromJsonMap(Map<String, dynamic> json , int classNumber){
    apiDetail = json['api_detail_url'];
    id        = json['id'];
    name      = json['name'];
    itemClass = classNumber;
  }
}
