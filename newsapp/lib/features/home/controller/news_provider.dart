import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:developer' as logger;

class NewsProvider extends ChangeNotifier {
  List trendingNews = [];
  bool isNewsLoading = false;
  Future getNews() async {
    isNewsLoading = true;
    notifyListeners();
    try {
      String url =
          "https://newsapi.org/v2/top-headlines?country=us&apiKey=0cab20d5ab0c4319bf61c504fd922466";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final data = decodedData["articles"];
        trendingNews = data;
      } else {
        logger.log("unable to fetch data");
      }
    } catch (err) {
      logger.log(err.toString());
    } finally {
      isNewsLoading = false;
    }
    notifyListeners();
  }
}
