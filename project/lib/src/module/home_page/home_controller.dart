import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:leitor_de_ebooks/src/model/books_model.dart';
import 'package:leitor_de_ebooks/src/repository/books_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  final BooksRepository _repository = Get.put(BooksRepository());
  RxList<Books> booksList = <Books>[].obs;
  RxList<Books> favoritoList = <Books>[].obs;
  RxBool loading = false.obs;
  RxBool loadingPage = false.obs;
  Dio dio = Dio();
  String filePath = "";

  @override
  void onInit() {
    buscarEbooks();
    super.onInit();
  }

  void buscarEbooks() {
    loadingPage.value = true;
    _repository.buscarLivros().then((value) {
      loadingPage.value = false;
      booksList.addAll(value);
    });
  }

  void adicionaAoFavorito(Books book) {
    favoritoList.add(book);
  }

  ///Metodo que peguei do repositorio original
  Future<void> download(String url, int id) async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (await Permission.storage.isGranted) {
        await Permission.storage.request();
        await startDownload(url, id);
      } else {
        await startDownload(url, id);
      }
    }
    loading.value = false;
  }

  ///Metodo que peguei do repositorio original
  startDownload(String url, int id) async {
    Directory? appDocDir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    String path = "${appDocDir!.path}/$id.epub";
    File file = File(path);
    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        url,
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          loading.value = true;
        },
      ).whenComplete(() {
        loading.value = false;
        filePath = path;
      });
    } else {
      loading.value = false;
      filePath = path;
    }
  }
}
