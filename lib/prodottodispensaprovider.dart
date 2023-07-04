import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottoDispensa.dart';
import 'package:flutter_application_1/prodottostoricoprovider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProdottoDispensaProvider with ChangeNotifier {
  List<ProdottoDispensa> _prodottiDispensa = [];

  List<ProdottoDispensa> get prodottiDispensa => _prodottiDispensa;

  void aggiungiProdotto(BuildContext context, ProdottoDispensa prodotto) {
    _prodottiDispensa.add(prodotto);
    notifyListeners();
    saveProdottiDispensa();
  }

  void rimuoviProdotto(String descrizioneProdotto) {
    _prodottiDispensa.removeWhere(
        (prodotto) => prodotto.descrizioneProdotto == descrizioneProdotto);
    notifyListeners();
    saveProdottiDispensa();
  }

  void aggiornaProdotto(
      ProdottoDispensa item, ProdottoDispensa prodottoModificato) {
    final index = _prodottiDispensa.indexOf(item);
    if (index != -1) {
      _prodottiDispensa[index] = prodottoModificato;
      notifyListeners();
      saveProdottiDispensa();
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

  void saveProdottiDispensa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = _prodottiDispensa
        .map((prodotto) => jsonEncode(prodotto.toJson()))
        .toList();
    await prefs.setStringList('prodottiDispensa', jsonList);
  }

  Future<void> loadProdottiDispensa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('prodottiDispensa');
    if (jsonList != null) {
      _prodottiDispensa = jsonList
          .map((json) => ProdottoDispensa.fromJson(jsonDecode(json)))
          .cast<ProdottoDispensa>()
          .toList();
    }
    notifyListeners();
  }

  void rimuoviProdottiDeselezionati() {
    _prodottiDispensa.removeWhere((prodotto) => !prodotto.comprato);
    notifyListeners();
    saveProdottiDispensa();
  }
}
