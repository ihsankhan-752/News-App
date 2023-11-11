import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/news_channel_headlines_model.dart';
import 'package:news_app/view/categories_screen/categories_screen.dart';
import 'package:news_app/view/news_details/news_detail.dart';
import 'package:news_app/view_model/news_view_model.dart';

import '../../model/category_news_model.dart';

enum FilterList {
  bbcNews,
  aryNews,
  reuters,
  cnn,
  alJazeera,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;

  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesScreen()));
          },
          icon: Image.asset('images/category_icon.png', height: 30, width: 30),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "News",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FilterList item) {
              if (FilterList.bbcNews.name == item.name) {
                name = 'bbc-news';
              }
              if (FilterList.aryNews.name == item.name) {
                name = 'ary-news';
              }

              if (FilterList.reuters.name == item.name) {
                name = 'reuters';
              }
              if (FilterList.cnn.name == item.name) {
                name = 'cnn';
              }
              if (FilterList.alJazeera.name == item.name) {
                name = 'al-jazeera-english';
              }
              setState(() {
                selectedMenu = item;
              });
              newsViewModel.fetchNewsChannelHeadlinesApi(name);
            },
            initialValue: selectedMenu,
            icon: const Icon(Icons.more_vert, color: Colors.black),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: FilterList.bbcNews,
                  child: Text("BBS News"),
                ),
                const PopupMenuItem(
                  value: FilterList.aryNews,
                  child: Text("Ary News"),
                ),
                const PopupMenuItem(
                  value: FilterList.reuters,
                  child: Text("Reuters"),
                ),
                const PopupMenuItem(
                  value: FilterList.cnn,
                  child: Text("CNN"),
                ),
                const PopupMenuItem(
                  value: FilterList.alJazeera,
                  child: Text("Al-Jazeera"),
                ),
              ];
            },
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.5,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt!);
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewsDetailScreen(
                                newsSource: snapshot.data!.articles![index].author!,
                                image: snapshot.data!.articles![index].urlToImage!,
                                title: snapshot.data!.articles![index].title!,
                                publishDate: dateTime,
                                description: snapshot.data!.articles![index].description!,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: height * 0.02),
                                height: height * 0.6,
                                width: width * 0.9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => spinKit2,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                                    height: height * 0.2,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: width * 0.7,
                                          child: Text(
                                            snapshot.data!.articles![index].title!,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          width: width * 0.7,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: width * 0.4,
                                                child: Text(
                                                  snapshot.data!.articles![index].author ?? "",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: Colors.teal,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                DateFormat('MMM d,y').format(dateTime),
                                                style: GoogleFonts.poppins(
                                                  color: Colors.teal,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: height * 0.8,
            child: FutureBuilder<CategoryNewsModel>(
              future: newsViewModel.fetchCategoryBaseNews('General'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      size: 50,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt!);

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewsDetailScreen(
                                newsSource: snapshot.data!.articles![index].author!,
                                image: snapshot.data!.articles![index].urlToImage!,
                                title: snapshot.data!.articles![index].title!,
                                publishDate: dateTime,
                                description: snapshot.data!.articles![index].description!,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: height * 0.02, vertical: 10),
                              height: height * 0.2,
                              width: width * 0.3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index].urlToImage!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => spinKit2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: height * .18,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        width: width * 0.7,
                                        child: Text(
                                          snapshot.data!.articles![index].title!,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: width * 0.3,
                                            child: Text(
                                              snapshot.data!.articles![index].author ?? "",
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color: Colors.teal,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            DateFormat('MMM d,y').format(dateTime),
                                            style: GoogleFonts.poppins(
                                              color: Colors.teal,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
