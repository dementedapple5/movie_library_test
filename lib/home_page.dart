
import 'package:flutter/material.dart';
import 'package:movie_library_test/custom_exp_tile.dart';
import 'package:movie_library_test/movie.dart';
import 'package:movie_library_test/movie_list_builder.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

var _currentSort = 'popular';
var _currentPage = 1;
List _movies = List<Movie>();
var _currentLanguage = 'en-US';
List data;
final _apiKey = '36778990a716e8ef5494fc710317e722';
var _isLoading = true;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  GlobalKey<ScaffoldState> _bodyKey;

  @override
  void initState() {
    super.initState();
    fetchMovies();
    _bodyKey = GlobalKey<ScaffoldState>();
    _scrollController.addListener(listEndListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(listEndListener);
    _scrollController.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _bodyKey,
      appBar: AppBar(title: Text(_currentSort == 'popular' ? 'Popular' : 'Rate Avg')),
      body: Stack(
        children: <Widget>[
          _movies.isEmpty
              ? Center(child: CircularProgressIndicator())
              : MoviesListView(
              movies: _movies, scrollController: _scrollController),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 40.0),
            child: _isLoading && _movies.isNotEmpty
                ? CircularProgressIndicator()
                : null,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showSearchForm(),
          icon: Icon(Icons.search),
          label: Text('Search movies')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        hasNotch: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(onPressed: () => {}, icon: Icon(Icons.menu)),
            IconButton(onPressed: () => showFilterMenu(), icon: Icon(Icons.more_vert)),
          ],
        ),
      ),
    );
  }


  void fetchMovies() async {

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
        'https://api.themoviedb.org/3/movie/$_currentSort?api_key=$_apiKey&language=$_currentLanguage&page=$_currentPage');

    if (response.statusCode == 200) {
      var moviesData = json.decode(response.body);
      data = moviesData['results'];
      for (Map elem in data) {
        _movies.add(Movie.fromJson(elem));
      }
    }

    setState(() {
      _isLoading = false;
    });

  }


  void listEndListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      _currentPage++;
      if (_searchController.text.isEmpty){
        fetchMovies();
      }else {
        searchMovies(_searchController.text);
      }

    }
  }

  void searchMovies(String query) async {

    setState(() {
      _isLoading = true;
    });

    final response  = await http.get('https://api.themoviedb.org/3/search/movie?api_key=$_apiKey&language=$_currentLanguage&query=$query&page=$_currentPage&include_adult=false');

    if (response.statusCode == 200) {
      var moviesData = json.decode(response.body);
      data = moviesData['results'];
      for (Map elem in data) {
        _movies.add(Movie.fromJson(elem));
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showSearchForm() {
    showModalBottomSheet(context: context, builder: (builder) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0))
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.black12
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Type something...',
                      border: InputBorder.none
                  ),
                  autofocus: true,
                  controller: _searchController,
                  onChanged: (value) {
                    if (value.length == 0){
                      _currentPage = 1;
                      _movies.clear();
                      fetchMovies();
                    }else {
                      _currentPage = 1;
                      _movies.clear();
                      searchMovies(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void showFilterMenu(){
    showModalBottomSheet(context: context, builder: (context){
      return _FilterForm(fetcher: this.fetchMovies);
    });
  }

}

class _FilterForm extends StatefulWidget{

  final Function fetcher;

  _FilterForm({this.fetcher});

  @override
  _FilterFormState createState() {
    return new _FilterFormState();
  }

}

class _FilterFormState extends State<_FilterForm> {

  final GlobalKey<AppExpansionTileState> orderTile = new GlobalKey();
  final GlobalKey<AppExpansionTileState> langTile = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppExpansionTile(
            key: orderTile,
            onExpansionChanged: (val) => val == true ? langTile.currentState.collapse() : print('hello'),
            title: Text('Order'),
            leading: Icon(Icons.sort),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    customLabel(labelText: "Popularity", sortType: "popular"),
                    customLabel(labelText: "Rating", sortType: "top_rated"),
                    customLabel(labelText: "Upcoming", sortType: "upcoming"),
                    customLabel(labelText: "Now Playing", sortType: "now_playing"),
                  ],
                ),
              )
            ],
          ),

          AppExpansionTile(
            onExpansionChanged: (val) => val == true ? orderTile.currentState.collapse() : print('hello'),
            key: langTile,
            leading: Icon(Icons.language),
            title: Text('Language'),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    customLabel(labelText: "Español", language: "es"),
                    customLabel(labelText: "English", language: "en-US"),
                    customLabel(labelText: "Français", language: "fr"),
                  ],
                ),
              )
            ],
          )

        ],
      ),
    );
  }

  Widget customLabel({String labelText, String language, String sortType}){
    return SwitchListTile(
      title: Text(labelText, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
      onChanged: (bool value) {
        setState(() {
          language != null ? _currentLanguage = language : _currentSort = sortType;
          _currentPage = 1;
          _movies.clear();
        });
        this.widget.fetcher();
        print(language != null ? _currentLanguage : _currentSort);
      },
      selected: language != null ? _currentLanguage == language : _currentSort == sortType,
      value: language != null ? _currentLanguage == language : _currentSort == sortType,
    );
  }

}