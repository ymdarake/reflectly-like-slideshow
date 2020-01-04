import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController ctrl = PageController(viewportFraction: 0.8);

  Stream slides;
  String activeTag = 'favorites';
  int currentPage = 0;
  final List<Map> db = [
    {
      'img': 'https://placehold.it/200x200',
      'tags': ['favorites'],
      'title': 'My favorite',
    },
    {
      'img': 'https://placehold.it/300x300',
      'tags': ['happy'],
      'title': 'Happiness!',
    },
    {
      'img': 'https://placehold.it/400x400',
      'tags': ['sad'],
      'title': 'Crying',
    },
  ];

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: slides,
        initialData: db,
        builder: (context, AsyncSnapshot snap) {
          List slideList = snap.data.toList();

          return PageView.builder(
            controller: ctrl,
            itemCount: slideList.length + 1,
            itemBuilder: (context, int currentIndex) {
              if (currentIndex == 0) {
                return _buildTagPage();
              } else if (slideList.length >= currentIndex) {
                bool active = currentIndex == currentPage;
                return _buildStoryPage(slideList[currentIndex - 1], active);
              }
            },
          );
        },
      ),
    );
  }

  _queryDb({String tag = 'favorites'}) {
    setState(() {
      // slides = Stream.fromIterable(db.where((data) {
      //   return data['tags'].contains(tag);
      // }));
      activeTag = tag;
    });
  }

  _buildStoryPage(Map data, bool active) {
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(data['img']),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black87,
              blurRadius: blur,
              offset: Offset(offset, offset),
            )
          ]),
      child: Center(
          child: Text(
        data['title'],
        style: TextStyle(
          fontSize: 40,
          color: Colors.white,
        ),
      )),
    );
  }

  _buildTagPage() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Your Stories',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text(
            'filter',
            style: TextStyle(color: Colors.black26),
          ),
          _buildButton('favorites'),
          _buildButton('happy'),
          _buildButton('sad'),
        ],
      ),
    );
  }

  _buildButton(tag) {
    Color color = tag == activeTag ? Colors.purple : Colors.white;
    return FlatButton(
      color: color,
      child: Text('#$tag'),
      onPressed: () => _queryDb(tag: tag),
    );
  }
}
