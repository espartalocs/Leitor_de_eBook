import 'package:get/get.dart';
import 'package:leitor_de_ebooks/src/model/books_model.dart';
import 'package:leitor_de_ebooks/src/repository/books_repository.dart';

class HomeController extends GetxController {
  final BooksRepository _repository = Get.put(BooksRepository());
  RxList<Books> booksList = <Books>[].obs;
  RxList<Books> favoritoList = <Books>[].obs;

  @override
  void onInit() {
    buscarEbooks();
    super.onInit();
  }

  void buscarEbooks() {
    _repository.buscarLivros().then((value) {
      booksList.addAll(value);
    });
  }

  void adicionaAoFavorito(Books book) {
    favoritoList.add(book);
  }
}
