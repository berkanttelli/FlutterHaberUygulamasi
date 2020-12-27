import 'package:flutter/material.dart';
import 'package:haberuygulamasi/auth.dart';
import 'package:haberuygulamasi/loginregisterPage.dart';
import 'package:haberuygulamasi/webviewPage.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'settingsPage.dart';

class NewsPage extends StatefulWidget {
  final String uid;
  _NewsPageState createState() => _NewsPageState(uid);
  NewsPage({Key key, @required this.uid}) : super(key: key);
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _textEditingController = TextEditingController();
  static const String aa_FEED = 'https://t24.com.tr/rss';
  // ignore: non_constant_identifier_names
  List<RssItem> aa_items;
  RssFeed aa_feed;
  // ignore: non_constant_identifier_names
  String aa_title;
  final String uid;
  GlobalKey<RefreshIndicatorState> _refreshKey;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> filters = List();
  Icon searchIcon = Icon(
    Icons.search,
    color: Colors.black,
  );
  Widget appbarTitle = Text("HABERLER");
  _NewsPageState(this.uid) {
    _textEditingController.addListener(() {
      setState(() {
        if (_textEditingController.text.isEmpty) {
          aa_items = aa_feed.items;
          filters.clear();
        } else {
          filters = _textEditingController.text.split(" ");

          aa_items = (filters != null && filters.isNotEmpty)
              ? aa_feed.items.where((element) {
                  for (String filter in filters) {
                    if (!element.title
                        .toLowerCase()
                        .contains(filter.toLowerCase())) {
                      return false;
                    }
                  }
                  return true;
                }).toList()
              : aa_items;
        }
      });
    });
  }
  Future<RssFeed> takeFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(aa_FEED);
      return RssFeed.parse(response.body);
    } catch (e) {
      return null;
    }
  }

  bool autoFocusON() {
    return true;
  }

  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    load();
  }

  load() async {
    takeFeed().then((value) {
      if (value == null || value.toString().isEmpty) {
        return;
      }
      updateFeed(value);
    });
  }

  updateFeed(RssFeed feed) {
    setState(() {
      aa_feed = feed;
      aa_items = feed.items;
    });
  }

  title(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      "$subTitle",
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(imageUrl) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset('assets/world.jpg'),
        imageUrl: imageUrl,
        height: 50,
        width: 70,
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    );
  }

  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  list() {
    return ListView.builder(
        itemCount: aa_items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = aa_items[index];
          return ListTile(
            title: title(item.title),
            subtitle: subtitle(item.pubDate),
            leading: thumbnail(item.enclosure.url),
            trailing: rightIcon(),
            contentPadding: EdgeInsets.all(5.0),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => WebViewExample(item.link))),
          );
        });
  }

  isFeedEmpty() {
    return null == aa_items || null == aa_items;
  }

  body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(child: list(), onRefresh: () => load());
  }

  popupFunction(String value) {
    if (value == Popupnames.signout) {
      signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginRegisterPage()));
    } else if (value == Popupnames.setting) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SettingsPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: appbarTitle,
        centerTitle: true,
        leading: IconButton(
          color: Colors.black,
          icon: searchIcon,
          onPressed: () {
            setState(() {
              if (this.searchIcon.icon == Icons.search) {
                this.searchIcon = Icon(Icons.close);
                this.appbarTitle = TextField(
                  decoration: InputDecoration(
                      hintText: "Başlıkta Ara",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45))),
                  controller: _textEditingController,
                  autofocus: autoFocusON(),
                );
              } else {
                this.searchIcon = Icon(Icons.search);
                this.appbarTitle = Text("HABERLER");
              }
            });
          },
        ),
        actions: [
          PopupMenuButton(
              onSelected: popupFunction,
              itemBuilder: (BuildContext context) {
                return Popupnames.choice.map((String choice) {
                  return PopupMenuItem(
                    child: Text(choice),
                    value: choice,
                  );
                }).toList();
              }),
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: body()),
        ],
      )),
    );
  }
}

class Popupnames {
  static const String setting = "Ayarlar";
  static const String signout = "Çıkış Yap";
  static const List<String> choice = <String>[setting, signout];
}

// RaisedButton(
//          onPressed: () => {
//            signOut(),
//           Navigator.of(context).pushReplacement(
//                MaterialPageRoute(builder: (context) => LoginRegisterPage()))
//          },
//          child: Text("Basardin Kral"),
//        )
