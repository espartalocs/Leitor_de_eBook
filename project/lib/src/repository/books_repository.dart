import 'package:leitor_de_ebooks/src/model/books_model.dart';
import 'package:leitor_de_ebooks/src/repository/rest_client.dart';

class BooksRepository {
  final RestClient _restClient = RestClient();

  Future<List<Books>> buscarLivros() async {
    String url = "https://escribo.com/books.json";
    return await _restClient.get(url).then((result) {
      return result.body.map((e) => Books.fromJson(e)).toList().cast<Books>();
    });
  }
}
