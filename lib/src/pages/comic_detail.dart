import 'package:comicbook/src/models/comic_model.dart';
import 'package:comicbook/src/providers/comics_provider.dart';
import 'package:flutter/material.dart';

class ComicDetail extends StatelessWidget {
  final comicsProvider = new ComicsProvider();
  @override
  Widget build(BuildContext context) {

    final Comic comic = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _createAppBar(comic),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _title(comic, context),
                _createAdditionalInfo(comic)
              ]
            ),
          )
        ],
      )
    );
  }

  Widget _createAdditionalInfo(Comic comic){
    return FutureBuilder(
      future: comicsProvider.getComicInfo(comic.apiDetailUrl),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          List<ComicInfoDetail> characters = snapshot.data.where((element) => element.itemClass==1).toList();
          List<ComicInfoDetail> concepts = snapshot.data.where((element) => element.itemClass==2).toList();
          List<ComicInfoDetail> locations = snapshot.data.where((element) => element.itemClass==3).toList();
          return Column(
            children: [
              _createAdditionalInfoPageView(characters, 'Characters'),
              _createAdditionalInfoPageView(concepts, 'Concepts'),
              _createAdditionalInfoPageView(locations, 'Locations')
            ],
          );
        }else{
          return Center(
            child: CircularProgressIndicator()
          );
        }
      }
    );
  }

  Widget _createAdditionalInfoPageView(List<ComicInfoDetail> comicInfoDet, String title){
    if (comicInfoDet.length == 0)
    { 
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          height: 150.0,
          child: PageView.builder(
            pageSnapping: false,
            itemCount: comicInfoDet.length,
            controller: PageController(
              viewportFraction: 0.3,
              initialPage: 1
            ),
            itemBuilder: (BuildContext context, int index){
              return FutureBuilder(
                future: comicsProvider.getInfoImage(comicInfoDet[index].apiDetail),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: FadeInImage(
                            placeholder: AssetImage('assets/loading.gif'),
                            image: NetworkImage(snapshot.data),
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(comicInfoDet[index].name)
                      ],
                    );
                  }else{
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              );
            },
          ),
        ),
      ],
    );
  }


  Widget _title(Comic comic, BuildContext context){
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Row(
          children: [
            Hero(
              tag: comic.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  image: NetworkImage(comic.image),
                  height: 150.0,
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comic.name,
                    style: Theme.of(context).textTheme.headline6,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    comic.dateAdded,
                    style: Theme.of(context).textTheme.subtitle1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _createAppBar(Comic comic){
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Color.fromRGBO(191, 149, 95, 1.0),
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          comic.name,
          style: TextStyle(
            fontSize: 16.0
          ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'), 
          image: NetworkImage(comic.screenImage),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}