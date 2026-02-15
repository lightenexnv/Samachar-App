import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:newsapp/models/newsModel.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/pages/WelcomePage.dart';
import 'package:newsapp/pages/favouriteNews.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/auth_controller.dart';

class newsPage extends StatefulWidget {
  const newsPage({super.key});

  @override
  State<newsPage> createState() => _newsPageState();
}

class _newsPageState extends State<newsPage> {
  List<Article> allArticles = [];

  Set<String> favouriteUrls = {};

  void toggleFavourite(String url){
    setState(() {
      if(favouriteUrls.contains(url)){
        favouriteUrls.remove(url);
      }else{
        favouriteUrls.add(url);
      }

    });
  }
  String formatDateTime(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}-"
        "${dateTime.month.toString().padLeft(2, '0')}-"
        "${dateTime.year}  "
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}";
  }



List<NewsModel> newslist = [];
Future<List<NewsModel>> getnewsapi() async{
final response = await http.get(Uri.parse("https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=49eae2ba70be4823a3244c4b66b741d0"));
var data = jsonDecode(response.body.toString());
if(response.statusCode==200){
  newslist.add(NewsModel.fromJson(data));
  return newslist;
}else{
  return newslist;
}
}

Future<void> openArticle(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}

Future<void> refreshNews() async {
  if (newslist.isNotEmpty) {
    setState(() {
      newslist[0].articles.shuffle();
    });
  }
}

  final controller = AuthController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(70),
          child: SafeArea(child:
          Padding(padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8
                )
              ]
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> WelcomePage()));
                  },
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),

                const Spacer(),

                const Text(
                  "News",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Spacer(),

                IconButton(
                    onPressed: () {
                      final favouriteArticles = allArticles
                          .where((article) => favouriteUrls.contains(article.url))
                          .toList();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FavouriteNews(
                            articles: favouriteArticles,
                          ),
                        ),
                      );
                    },
                  icon: Hero(tag:'heart-tag',child: const Icon(Icons.favorite, color: Colors.red)),
                ),
                IconButton(
                  onPressed: () async {
                    await controller.logout();

                    if (!mounted) return;

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomePage()),
                          (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                ),

              ],
            ),

          ),))),
      body: Hero(
        tag: 'news-button',
        child: Material(
          color: Colors.white,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(child:
                FutureBuilder(future: getnewsapi(),
                    builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator());
                  }else{

                    final articles = snapshot.data![0].articles;
                    if (allArticles.isEmpty) {
                      allArticles = articles;
                    }

                    return RefreshIndicator(
                      onRefresh: refreshNews,
                      child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),itemCount: articles.length,
                          itemBuilder: (context,index){
                            return GestureDetector(
                              onTap: () {
                                openArticle(articles[index].url);
                              },
                              child: Card(
                                margin: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        if (articles[index].imageUrl != null)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: Image.network(
                                                articles[index].imageUrl!,
                                                height: 200,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                        Positioned(
                                          top: 16,
                                          right: 16,
                                          child: GestureDetector(
                                            onTap: () {
                                              toggleFavourite(articles[index].url);
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                favouriteUrls.contains(articles[index].url)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: favouriteUrls.contains(articles[index].url)
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            articles[index].title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            articles[index].description,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),

                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.schedule,
                                                  size: 14,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  formatDateTime(articles[index].publishedAt),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );

                          }),
                    );
                  }
                }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
