// import 'dart:async';

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leitor_de_ebooks/src/module/favorito/favorito_page.dart';
import 'package:leitor_de_ebooks/src/module/home_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
//import 'package:vocsy_epub_viewer/epub_viewer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  Dio dio = Dio();
  String filePath = "";

  // @override
  // void initState() {
  //   download();
  //   super.initState();
  // }

  download(String url) async {
    if (Platform.isAndroid || Platform.isIOS) {
      String? firstPart;
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.deviceInfo;
      final allInfo = deviceInfo.data;
      if (allInfo['version']["release"].toString().contains(".")) {
        int indexOfFirstDot = allInfo['version']["release"].indexOf(".");
        firstPart = allInfo['version']["release"].substring(0, indexOfFirstDot);
      } else {
        firstPart = allInfo['version']["release"];
      }
      int intValue = int.parse(firstPart!);
      if (intValue >= 13) {
        await startDownload(url);
      } else {
        if (await Permission.storage.isGranted) {
          await Permission.storage.request();
          await startDownload(url);
        } else {
          await startDownload(url);
        }
      }
    } else {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leitor de Ebooks"),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text("Livros")),
                  const SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () async {
                        await Get.to(() => const FavoritoPage(), arguments: "");
                      },
                      child: const Text("Favoritos")),
                ],
              ),
            ),
            Expanded(
              child: ListView(children: [
                Wrap(
                    direction: Axis.horizontal,
                    children: controller.booksList.map((element) {
                      return SizedBox(
                        width: 300,
                        height: 300,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                print("=====filePath======$filePath");
                                if (filePath == "") {
                                  download(element.downloadUrl!);
                                } else {
                                  VocsyEpub.setConfig(
                                    themeColor: Theme.of(context).primaryColor,
                                    identifier: "iosBook",
                                    scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                                    allowSharing: true,
                                    enableTts: true,
                                    nightMode: true,
                                  );
                                  VocsyEpub.locatorStream.listen((locator) {
                                    print('LOCATOR: $locator');
                                  });

                                  VocsyEpub.open(
                                    filePath,
                                    // lastLocation: EpubLocator.fromJson({
                                    //   "bookId": "2239",
                                    //   "href": "/OEBPS/ch06.xhtml",
                                    //   "created": 1539934158390,
                                    //   "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
                                    // }),
                                  );
                                }
                              },
                              child: Stack(
                                children: [
                                  Image.network(
                                    "${element.coverUrl}",
                                    width: 100,
                                    height: 200,
                                  ),
                                ],
                              ),
                            ),
                            Text('Título: ${element.title}'),
                            Text('Autor: ${element.author}')
                          ],
                        ),
                      );
                    }).toList()),
              ]),
            )
          ],
        ),
      ),
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     ElevatedButton(
      //       onPressed: () async {
      //         print("=====filePath======$filePath");
      //         if (filePath == "") {
      //           download();
      //         } else {
      //           VocsyEpub.setConfig(
      //             themeColor: Theme.of(context).primaryColor,
      //             identifier: "iosBook",
      //             scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      //             allowSharing: true,
      //             enableTts: true,
      //             nightMode: true,
      //           );

      //           // get current locator
      //           VocsyEpub.locatorStream.listen((locator) {
      //             print('LOCATOR: $locator');
      //           });

      //           VocsyEpub.open(
      //             filePath,
      //             lastLocation: EpubLocator.fromJson({
      //               "bookId": "2239",
      //               "href": "/OEBPS/ch06.xhtml",
      //               "created": 1539934158390,
      //               "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
      //             }),
      //           );
      //         }
      //       },
      //       child: Text('Open Online E-pub'),
      //     ),
      //     ElevatedButton(
      //       onPressed: () async {
      //         VocsyEpub.setConfig(
      //           themeColor: Theme.of(context).primaryColor,
      //           identifier: "iosBook",
      //           scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      //           allowSharing: true,
      //           enableTts: true,
      //           nightMode: true,
      //         );
      //         // get current locator
      //         VocsyEpub.locatorStream.listen((locator) {
      //           print('LOCATOR: $locator');
      //         });
      //         await VocsyEpub.openAsset(
      //           'assets/4.epub',
      //           lastLocation: EpubLocator.fromJson({
      //             "bookId": "2239",
      //             "href": "/OEBPS/ch06.xhtml",
      //             "created": 1539934158390,
      //             "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
      //           }),
      //         );
      //       },
      //       child: Text('Open Assets E-pub'),
      //     ),
      //   ],
      // ),
    );
  }

  startDownload(String url) async {
    Directory? appDocDir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();

    String path = '${appDocDir!.path}/sample.epub';
    File file = File(path);

    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        url,
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            loading = true;
          });
        },
      ).whenComplete(() {
        setState(() {
          loading = false;
          filePath = path;
        });
      });
    } else {
      setState(() {
        loading = false;
        filePath = path;
      });
    }
  }
}
