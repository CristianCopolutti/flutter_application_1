import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/product.dart';

//provider libreria che facilita la gestione dello stato dell'applicazione
/*
- definizione provider --> contiene i dati da condividere; classe personalizzata che estende ChangeNotifier
- consumo del provider --> all'interno del widget figlio si può accedere ai dati forniti dal provider utilizzando il widget Consumer; questo widget automaticamente accede ai cambiamenti dei dati forniti e si aggiorna quando i dati cambiano
- quando i dati all'interno del provider cambiano si possono chiamare i metodi 'notifyListeners per ChangeNotifier per informare i widget che i dati sono stati modificati
*/

class ShoppingListProvider extends ChangeNotifier {
  List<Product> listaProdottiSpesa = [];

  void aggiungiProdotto(Product prodotto) {
    listaProdottiSpesa.add(prodotto);
    notifyListeners();
  }

  void removeProduct(int index) {
    listaProdottiSpesa.removeAt(index);
    notifyListeners();
  }
}
