import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hidable/hidable.dart';
import 'package:leitor_de_ebooks/src/model/books_model.dart';
import 'package:leitor_de_ebooks/src/module/home_page/home_controller.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final platform = const MethodChannel('my_channel');
  @override
  Widget build(BuildContext context) {
    RxInt indexNavigator = 0.obs;
    HomeController controller = Get.put(HomeController());
    final scrollController = ScrollController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Leitor de e-Pub", style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Obx(
          () => controller.loadingPage.value
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            controller: scrollController,
                            itemCount: controller.booksList.length,
                            separatorBuilder: (BuildContext contex, int intex) {
                              return Container(
                                height: 20,
                                color: Colors.black,
                              );
                            },
                            itemBuilder: (BuildContext contex, int intex) {
                              Books book = controller.booksList[intex];
                              return Card(
                                color: Colors.white38,
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          controller.download(book.downloadUrl!, book.id!).whenComplete(() {
                                            VocsyEpub.setConfig(
                                              themeColor: Theme.of(context).primaryColor,
                                              identifier: "id",
                                              scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                                              allowSharing: true,
                                              enableTts: false,
                                              nightMode: true,
                                            );
                                            VocsyEpub.locatorStream.listen((locator) {});
                                            VocsyEpub.open(
                                              controller.filePath,
                                            );
                                          });
                                        },
                                        child: Image.network(
                                          "${book.coverUrl}",
                                          width: 100,
                                          height: 200,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(child: Text('Título: ${book.title}', style: const TextStyle(color: Colors.white))),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Autor: ${book.author}', style: const TextStyle(color: Colors.white)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
        ),

        ///Será implementado futuramente a aba de favoritos
        bottomNavigationBar: Hidable(
          controller: scrollController,
          child: BottomNavigationBar(
            currentIndex: indexNavigator.value,
            items: bottomBarItems(),
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> bottomBarItems() {
    return [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      const BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favoritos"),
    ];
  }
}
