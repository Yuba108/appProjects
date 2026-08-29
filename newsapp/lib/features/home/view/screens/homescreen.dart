import 'package:flutter/material.dart';
import 'package:newsapp/common/common_colors.dart';
import 'package:newsapp/features/home/controller/news_provider.dart';
import 'package:newsapp/features/home/controller/theme_provider.dart';
import 'package:newsapp/features/home/model/category_data.dart';
import 'package:newsapp/features/home/view/screens/categoryscreen.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as logger;

import 'package:url_launcher/url_launcher.dart';

// import 'package:url_launcher/url_launcher.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().getNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: .center,
          spacing: 0,
          children: [
            Text("World", style: TextStyle(fontWeight: .bold)),
            Text(
              "News",
              style: TextStyle(
                fontWeight: .bold,
                color: commonColors.primaryColor,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              context.read<ThemeProvider>().switchTheme();
            },
            child: Consumer<ThemeProvider>(
              builder: (context, provider, child) {
                return provider.theme == ThemeData.dark()
                    ? Icon(Icons.light_mode)
                    : Icon(Icons.dark_mode);
              },
            ),
          ),
        ],
        actionsPadding: EdgeInsets.all(10),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: .horizontal,
                  itemCount: CategoryData.categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Categoryscreen(
                                  category: CategoryData.categories[index],
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          width: 130,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: .circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Colors.lightBlue[100]!,
                                Colors.blue[900]!,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(CategoryData.categories[index]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: .topStart,
                  child: Text(
                    "Trending News",
                    style: TextStyle(fontSize: 20, fontWeight: .bold),
                  ),
                ),
              ),
              Expanded(
                child: Consumer<NewsProvider>(
                  builder: (context, provider, child) {
                    return provider.isNewsLoading == true
                        ? Center(child: CircularProgressIndicator())
                        : provider.trendingNews.isEmpty
                        ? Center(child: Text("no news"))
                        : ListView.builder(
                            itemCount: provider.trendingNews.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: GestureDetector(
                                  onTap: () {
                                    String url =
                                        provider.trendingNews[index]["url"];
                                    logger.log(url);
                                    launchUrl(Uri.parse(url));
                                  },
                                  child: Container(
                                    clipBehavior: .hardEdge,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: .circular(10),
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        Image.network(
                                          fit: .cover,
                                          height: 100,
                                          width: 100,
                                          provider.trendingNews[index]['urlToImage'] ?? "https://static.vecteezy.com/system/resources/previews/024/174/781/non_2x/juicy-fruits-top-view-background-ai-generative-photo.jpg",
                                          // errorBuilder for wrong url but not null
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  height: 100,
                                                  width: 100,
                                                  color: Colors.grey,
                                                );
                                              },
                                        ),
                                        Expanded(
                                          child: Column(
                                            spacing: 10,
                                            children: [
                                              Text(
                                                provider.trendingNews[index]['title'] ??
                                                    "no title",
                                                maxLines: 2,
                                                overflow: .ellipsis,
                                                style: TextStyle(
                                                  fontWeight: .bold,
                                                ),
                                              ),
                                              Text(
                                                provider.trendingNews[index]['description'] ??
                                                    "no description",
                                                maxLines: 2,
                                                overflow: .ellipsis,
                                                style: TextStyle(
                                                  fontWeight: .w400,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
