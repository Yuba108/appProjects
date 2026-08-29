import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:developer' as logger;

class CategoryNewsProvider extends ChangeNotifier {
  List categoryNews = [];
  bool isLoading = false;

  Future getCategoryNews(String category) async {
    isLoading = true;
    notifyListeners();
    try {
      String url =
          "https://newsapi.org/v2/top-headlines?country=us&category=${category.toLowerCase()}&apiKey=0cab20d5ab0c4319bf61c504fd922466";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final data = decodedData["articles"];
        categoryNews = data;
      } else {
        logger.log("error");
      }
    } catch (err) {
      logger.log(err.toString());
    } finally {
      isLoading = false;
    }
    notifyListeners();
  }
}
