import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leitor_de_ebooks/src/module/home_page/home_controller.dart';

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
        body: Container());
  }
}
