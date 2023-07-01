import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/prodottoDispensa.dart';
import 'package:intl/intl.dart';

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

  void ordinaProdottiPerScadenza(String order) {
    prodottiDispensa.sort((a, b) {
      DateTime? dataScadenzaA =
          a.dataScadenza != null && a.dataScadenza?.isNotEmpty == true
              ? DateFormat('dd/MM/yyyy').parse(a.dataScadenza!)
              : null;
      DateTime? dataScadenzaB =
          b.dataScadenza != null && b.dataScadenza?.isNotEmpty == true
              ? DateFormat('dd/MM/yyyy').parse(b.dataScadenza!)
              : null;

      if (dataScadenzaA == null && dataScadenzaB == null) {
        return 0;
      } else if (dataScadenzaA == null) {
        return 1;
      } else if (dataScadenzaB == null) {
        return -1;
      }

      if (order == 'asc') {
        return dataScadenzaA.compareTo(dataScadenzaB);
      } else {
        return dataScadenzaB.compareTo(dataScadenzaA);
      }
    });

    notifyListeners();
  }
}
