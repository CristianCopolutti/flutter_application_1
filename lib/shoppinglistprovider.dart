import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/product.dart';

class ShoppingListProvider extends ChangeNotifier {
  List<Product> listaspesa = [];

  void aggiungiProdotto(Product prodotto) {
    listaspesa.add(prodotto);
    notifyListeners();
  }

  void removeProduct(int index) {
    listaspesa.removeAt(index);
    notifyListeners();
  }

  void modificaProdotto(int index, Product nuovoProdotto) {
    listaspesa[index] = nuovoProdotto;
    notifyListeners();
  }
}
