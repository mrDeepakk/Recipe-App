import 'dart:convert';
import 'package:epicrecepi/Screens/recepi_view.dart';
import 'package:epicrecepi/Screens/search_screen.dart';
import 'package:epicrecepi/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  List<RecepiModel> recepiList = <RecepiModel>[];
  getApiData(querry) async {
    recepiList = [];
    Response response = await get(Uri.parse(
        "https://api.edamam.com/search?q=$querry&app_id=057f9fa4&app_key=875e63f016a1187db3c5907e65434f0b"));
    Map jsonData = jsonDecode(response.body);
    // print(jsonData["hits"]);

    jsonData["hits"].forEach((element) {
      RecepiModel recepiModel = new RecepiModel();
      recepiModel = RecepiModel.fromMap(element["recipe"]);
      recepiList.add(recepiModel);
    });
    // recepiList.forEach((element) {
    //   print("==================================");
    //   print(element.level);
    //   print("==================================");
    // });
    setState(() {
      isLoading = false;
    });
  }

  @override
  initState() {
    getApiData("ladoo");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.black],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Container(
                    height: 65,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35)),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: "search",
                          prefix: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => searchScreen(
                                        searchController.text.toString()),
                                  ));
                              if ((searchController.text).replaceAll(" ", "") ==
                                  "") {
                                print("Blank search");
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                getApiData(searchController.text);
                              }
                            },
                            icon: Icon(Icons.search, color: Colors.blue),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () => searchController.clear(),
                            icon: Icon(Icons.clear),
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What Do You Want To Cook Today ?",
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontFamily: "poppins"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Let's Cook Something New !",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: "poppins"),
                        ),
                      ]),
                ),
                Container(
                    child: isLoading
                        ? Container(
                            height: MediaQuery.of(context).size.height / 1.8,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: recepiList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  child: InkWell(
                                    onTap: () {
                                      String temp = recepiList[index].sourceUrl;
                                      if (temp.contains("https://")) {
                                        temp = temp;
                                      } else {
                                        temp = temp.replaceAll(
                                            "http://", "https://");
                                      }

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RecipeViewPage(temp),
                                          ));
                                    },
                                    child: Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Stack(
                                          children: [
                                            // Text(recepiList[index].level),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                recepiList[index].imgUrl,
                                                fit: BoxFit.cover,
                                                height: 305,
                                                width: double.infinity,
                                              ),
                                            ),
                                            Positioned(
                                              left: 0,
                                              bottom: 0,
                                              right: 0,
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 13),
                                                decoration: BoxDecoration(
                                                    color: Colors.black26,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft: Radius
                                                                .circular(20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20))),
                                                child: Text(
                                                  recepiList[index].level,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              width: 90,
                                              height: 35,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20))),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons
                                                            .local_fire_department),
                                                        Text(
                                                          recepiList[index]
                                                              .calories
                                                              .toString()
                                                              .substring(0, 6),
                                                          style: TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                              );
                            })),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
