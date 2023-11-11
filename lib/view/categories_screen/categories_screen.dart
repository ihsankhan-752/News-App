import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/model/category_news_model.dart';
import 'package:news_app/view_model/news_view_model.dart';

import '../home/home_screen.dart';
import '../news_details/news_detail.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  String selectedCategory = 'General';
  List<String> categories = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology',
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Categories",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.06,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedCategory == categories[index] ? Colors.teal : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                    child: Text(
                      categories[index].toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: selectedCategory == categories[index] ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: height * 0.8,
            child: FutureBuilder<CategoryNewsModel>(
              future: newsViewModel.fetchCategoryBaseNews(selectedCategory),
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
                                  imageUrl: snapshot.data!.articles![index].urlToImage ?? "",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => spinKit2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: height * .2,
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
                                            width: width * 0.35,
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
                                              fontSize: 12,
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
