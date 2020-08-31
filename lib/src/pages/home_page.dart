import 'package:comicbook/src/models/comic_model.dart';
import 'package:comicbook/src/providers/comics_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollControllerList = new ScrollController();
  final comicsProvider = new ComicsProvider();
  bool _isLoading = false;
  bool _list = false;

  @override
  void initState() {
    super.initState();
    comicsProvider.getIssues();
    _scrollController.addListener(() { 
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        _isLoading = true;
        setState(() {});
        final future = comicsProvider.getIssues();
        future.then((value) {
          _isLoading = false;
          _scrollController.animateTo(
            _scrollController.position.pixels + 100, 
            duration: Duration(milliseconds: 250), 
            curve: Curves.fastOutSlowIn);
          setState(() {});
        });
      }
    });
    _scrollControllerList.addListener(() { 
      if(_scrollControllerList.position.pixels == _scrollControllerList.position.maxScrollExtent){
        _isLoading = true;
        setState(() {});
        final future = comicsProvider.getIssues();
        future.then((value) {
          _isLoading = false;
          _scrollControllerList.animateTo(
            _scrollControllerList.position.pixels + 100, 
            duration: Duration(milliseconds: 250), 
            curve: Curves.fastOutSlowIn);
          setState(() {});
        });
      }
    });
    
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ComicBook'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(191, 149, 95, 1.0),
      ),
      body: Stack(
        children: [
          _createBackground(),
          _createComicLibrary(context),
          _createLoading()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: (_list)?Icon(Icons.grid_on):Icon(Icons.list),
        onPressed: (){
          if(_list){
            _list = false;
          }else{
            _list = true;
          }
          setState(() {
            comicsProvider.getIssues();
          });
        },
        backgroundColor: Color.fromRGBO(97, 57, 25, 1.0),
      ),
    );
  }

  Widget _createBackground(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(0.0, 1.0),
          colors: [
            Color.fromRGBO(45, 28, 21, 1.0),
            Color.fromRGBO(107, 70, 51, 1.0),
            Color.fromRGBO(45, 28, 21, 1.0),
          ]
        )
      ),
    );
  }

  Widget _createComicLibrary(BuildContext context){
    return StreamBuilder(
      stream: comicsProvider.comicsStream,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if (snapshot.hasData){
          if(_list){
            return _createComicList(context, snapshot.data); 
          }
          return _createComicGrid(context, snapshot.data);
        }
        return Center(
          child: CircularProgressIndicator()
        );
      }
    );
  }

  Widget _createComicList(BuildContext context, List<Comic> comics){
    return ListView.builder(
      controller: _scrollControllerList,
      itemCount: comics.length,
      itemBuilder: (BuildContext context, int index){
        return _createComicListCell(context, comics[index]);
      },
    );
  }

  Widget _createComicListCell(BuildContext context, Comic comic){
    final screenSize = MediaQuery.of(context).size;
    final listCell = Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              comic.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              comic.dateAdded,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Container(
              child: Hero(
                  tag: comic.id,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/loading.gif'), 
                    image: NetworkImage(comic.image),
                    height: screenSize.height * 0.4,
                    fit: BoxFit.contain,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
    return GestureDetector(
      child: listCell,
      onTap: () {
        Navigator.pushNamed(context, 'comicDetail', arguments: comic);
      },
    );
  }

  Widget _createComicGrid(BuildContext context, List<Comic> comics){
    final orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      controller: _scrollController,
      itemCount: comics.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3
      ),
      itemBuilder: (BuildContext context, int index){
        return _createComicGridCell(context, comics[index], orientation);
      },
      );
  }

  Widget _createShelf(){
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image(
            image: AssetImage('assets/wood_shelf.png'),
            fit: BoxFit.fill
          ),
        ],
      ),
    );
  }

  Widget _createComicGridCell(BuildContext context, Comic comic, Orientation orientation){
    final screenSize = MediaQuery.of(context).size;
    final libraryCell = Container(
          width: screenSize.width * 0.5,
          child: Stack(
            children: [
              _createShelf(),
              Center(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints){
                    double biggestHeight = constraints.biggest.height;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                          child: Text(
                            comic.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Hero(
                          tag: comic.id,
                          child: FadeInImage(
                            placeholder: AssetImage('assets/loading.gif'), 
                            image: NetworkImage(comic.image),
                            height: biggestHeight * 0.67,
                          ),
                        ),
                        SizedBox(height: (orientation == Orientation.portrait) ? biggestHeight*0.035 : biggestHeight*0.08),
                        Text(
                          comic.dateAdded,
                          style: TextStyle(
                            color:Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        )
                      ],
                    );
                  }
                )
              ),
            ],
          ),
        );

    return GestureDetector(
      child: libraryCell,
      onTap: () {
        Navigator.pushNamed(context, 'comicDetail', arguments: comic);
      },
    );
  }

  Widget _createLoading(){
    if(_isLoading){
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          ),
          SizedBox(height: 15.0)
        ],
      );
    }else{
      return Container();
    }
  }
}