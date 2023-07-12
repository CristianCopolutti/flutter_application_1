import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/*
- definizione provider --> contiene i dati da condividere; classe personalizzata che estende ChangeNotifier
- consumo del provider --> all'interno del widget figlio si può accedere ai dati forniti dal provider utilizzando il widget Consumer; questo widget automaticamente accede ai cambiamenti dei dati forniti e si aggiorna quando i dati cambiano
- quando i dati all'interno del provider cambiano si possono chiamare i metodi 'notifyListeners per ChangeNotifier per informare i widget che i dati sono stati modificati
- Provider.of --> permette di accedere ai dati senza dover specificare esplicitamente l'abbonamento ai cambiamenti
*/

class ShoppingListProvider extends ChangeNotifier {
  List<Product> _shoppingList = [];
  SharedPreferences? _prefs;

  List<Product> get listaProdottiSpesa => _shoppingList;

  ShoppingListProvider() {
    loadShoppingList();
  }

  Future<void> loadShoppingList() async {
    _prefs = await SharedPreferences.getInstance();
    final jsonString = _prefs!.getString('shoppingList');

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      _shoppingList = jsonList.map((item) => Product.fromJson(item)).toList();
    }

    notifyListeners();
  }

  Future<void> saveShoppingList() async {
    if (_prefs != null) {
      final jsonString = json.encode(_shoppingList);
      await _prefs!.setString('shoppingList', jsonString);
    }
  }

  void aggiungiProdotto(Product prodotto) {
    listaProdottiSpesa.add(prodotto);
    saveShoppingList();
    notifyListeners();
  }

  void removeProduct(index) {
    listaProdottiSpesa.removeAt(index);
    saveShoppingList();
    notifyListeners();
  }

  void setProdottoAcquistato(int index, bool acquistato) {
    listaProdottiSpesa[index].comprato = acquistato;
    saveShoppingList();
    notifyListeners();
  }

  void selezionaTutto() {
    for (var prodotto in listaProdottiSpesa) {
      prodotto.comprato = true;
    }
    saveShoppingList();
    notifyListeners();
  }

  void deselezionaTutto() {
    for (var prodotto in listaProdottiSpesa) {
      prodotto.comprato = false;
    }
    saveShoppingList();
    notifyListeners();
  }

  void rimuoviLista() {
    listaProdottiSpesa.clear();
    saveShoppingList();
    notifyListeners();
  }

  void spuntaTuttiProdotti(bool spuntato) {
    for (var prodotto in listaProdottiSpesa) {
      prodotto.comprato = false;
    }
    saveShoppingList();
    notifyListeners();
  }
}
