import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/prodottoDispensa.dart';

class ProdottoDispensaProvider with ChangeNotifier {
  List<ProdottoDispensa> _prodottiDispensa = [];

  List<ProdottoDispensa> get prodottiDispensa => _prodottiDispensa;

  void aggiungiProdotto(ProdottoDispensa prodotto) {
    _prodottiDispensa.add(prodotto);
    notifyListeners();
  }

  void rimuoviProdotto(String descrizioneProdotto) {
    _prodottiDispensa.removeWhere(
        (prodotto) => prodotto.descrizioneProdotto == descrizioneProdotto);
    notifyListeners();
  }

  void aggiornaProdotto(
      ProdottoDispensa item, ProdottoDispensa prodottoModificato) {
    final index = _prodottiDispensa.indexOf(item);
    if (index != -1) {
      _prodottiDispensa[index] = prodottoModificato;
      notifyListeners();
    }
  }
}
