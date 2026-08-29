import 'package:flutter/material.dart';
import 'package:newsapp/features/home/controller/category_news_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Categoryscreen extends StatefulWidget {
  final String category;
  const Categoryscreen({super.key, required this.category});

  @override
  State<Categoryscreen> createState() => _CategoryscreenState();
}

class _CategoryscreenState extends State<Categoryscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryNewsProvider>().getCategoryNews(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category), centerTitle: true),
      body: Consumer<CategoryNewsProvider>(
        builder: (context, provider, child) {
          return provider.isLoading == true
              ? Center(child: CircularProgressIndicator())
              : provider.categoryNews.isEmpty
              ? Center(child: Text("no news"))
              : ListView.builder(
                  itemCount: provider.categoryNews.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          String url = provider.categoryNews[index]["url"];

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
                                provider.categoryNews[index]['urlToImage'] ?? "https://static.vecteezy.com/system/resources/previews/024/174/781/non_2x/juicy-fruits-top-view-background-ai-generative-photo.jpg",
                                // errorBuilder for wrong url but not null
                                errorBuilder: (context, error, stackTrace) {
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
                                      provider.categoryNews[index]['title'] ??
                                          "no title",
                                      maxLines: 2,
                                      overflow: .ellipsis,
                                      style: TextStyle(fontWeight: .bold),
                                    ),
                                    Text(
                                      provider.categoryNews[index]['description'] ??
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
    );
  }
}
