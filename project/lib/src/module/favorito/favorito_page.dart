import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leitor_de_ebooks/src/module/home_controller.dart';

class FavoritoPage extends StatefulWidget {
  const FavoritoPage({super.key});

  @override
  State<FavoritoPage> createState() => _FavoritoPageState();
}

class _FavoritoPageState extends State<FavoritoPage> {
  HomeController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Favoritos"),
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
                        onPressed: () {}, child: const Text("Favoritos")),
                  ],
                ),
              ),
              Expanded(
                child: ListView(children: [
                  Wrap(
                      direction: Axis.horizontal,
                      children: controller.favoritoList.map((element) {
                        return SizedBox(
                          width: 300,
                          height: 300,
                          child: Column(
                            children: [
                              GestureDetector(
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
