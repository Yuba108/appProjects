import 'package:flutter/material.dart';
import 'package:shopiza/common/common_text.dart';

class Homescreen extends StatelessWidget {
  new({super.key});
  final List categoryIcons = [
    Icon(Icons.man_2_rounded, color: Colors.white),
    Icon(Icons.electric_bolt_outlined, color: Colors.white),
    Icon(Icons.home, color: Colors.white),
    Icon(Icons.network_cell_sharp, color: Colors.white),
    Icon(Icons.sports_football, color: Colors.white),
    Icon(Icons.book, color: Colors.white),
  ];
  final List category = [
    'Fashion',
    'Electronic',
    'Home',
    'Beauty',
    'Sports',
    'Ebook',
  ];

  final List colors = [
    Colors.black,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.pinkAccent,
    Colors.orange[300],
    Colors.orangeAccent[100],
  ];

  final List trendingImages = ['assets/shoes.png', 'assets/makeup.png'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shopiza",
          style: TextStyle(fontWeight: .bold, fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: .vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 10,
              crossAxisAlignment: .start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hint: Text("search products"),
                    suffixIcon: Icon(Icons.filter_alt_outlined),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white70,
                        Colors.deepOrangeAccent.shade100,
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: .start,
                          mainAxisSize: .min,
                          spacing: 10,
                          children: [
                            Column(
                              crossAxisAlignment: .start,
                              children: [
                                CommonText(text: "Apple"),
                                CommonText(text: "Airpods Max"),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                              child: Text("Shop now"),
                            ),
                          ],
                        ),
                        Image.asset(
                          "assets/headphone.png",
                          height: 150,
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                ),
                CommonText(text: "Categories"),
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: GridView.builder(
                    itemCount: category.length,
                    scrollDirection: .vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors[index],
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Column(
                              mainAxisAlignment: .center,
                              children: [
                                categoryIcons[index],
                                Text(
                                  category[index],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    CommonText(text: "Trending Now"),
                    Text("See All", style: TextStyle(fontWeight: .bold)),
                  ],
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: .horizontal,
                    itemCount: trendingImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: .hardEdge, // default ma none hunxa
                              child: Image.asset(
                                trendingImages[index],
                                height: 150,
                                width: 200,
                                fit: .cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  iconSize: 20,
                                  shape: CircleBorder(),
                                  backgroundColor: Colors.grey[400],
                                ),
                                onPressed: () {},
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
