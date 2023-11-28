// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leitor_de_ebooks/src/module/favorito/favorito_page.dart';
import 'package:leitor_de_ebooks/src/module/home_controller.dart';
//import 'package:vocsy_epub_viewer/epub_viewer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                    ElevatedButton(
                        onPressed: () {}, child: const Text("Livros")),
                    const SizedBox(width: 20),
                    ElevatedButton(
                        onPressed: () async {
                          await Get.to(() => const FavoritoPage(),
                              arguments: "");
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
                                onDoubleTap: () =>
                                    controller.adicionaAoFavorito(element),
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
        ));
  }
}
