import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottoDispensa.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProdottoDispensaProvider with ChangeNotifier {
  List<ProdottoDispensa> _prodottiDispensa = [];
  Map<String, List<ProdottoDispensa>> prodottiStoricoMap = {};

  List<ProdottoDispensa> get prodottiDispensa => _prodottiDispensa;

  void aggiungiProdotto(BuildContext context, ProdottoDispensa prodotto) {
    _prodottiDispensa.add(prodotto);

    if (prodottiStoricoMap.containsKey(prodotto.descrizioneProdotto)) {
      prodottiStoricoMap[prodotto.descrizioneProdotto]!.add(prodotto);
    } else {
      prodottiStoricoMap[prodotto.descrizioneProdotto] = [prodotto];
    }

    notifyListeners();
    saveProdottiDispensa();
    saveProdottiStorico();
  }

  void rimuoviProdotto(String descrizioneProdotto) {
    _prodottiDispensa.removeWhere(
        (prodotto) => prodotto.descrizioneProdotto == descrizioneProdotto);
    notifyListeners();
    saveProdottiDispensa();
  }

  void rimuoviProdottoDispensa(ProdottoDispensa prodotto) {
    _prodottiDispensa.remove(prodotto);
    notifyListeners();
    saveProdottiDispensa();
  }

  void rimuoviProdottoStorico(String descrizioneProdotto) {
    prodottiStoricoMap.remove(descrizioneProdotto);
    notifyListeners();
    saveProdottiStorico();
  }

  void aggiornaProdotto(
      ProdottoDispensa item, ProdottoDispensa prodottoModificato) {
    final index = _prodottiDispensa.indexOf(item);
    if (index != -1) {
      _prodottiDispensa[index] = prodottoModificato;

      if (prodottiStoricoMap.containsKey(item.descrizioneProdotto)) {
        final prodottiStorico = prodottiStoricoMap[item.descrizioneProdotto]!;
        if (prodottiStorico.isNotEmpty) {
          final ultimoProdotto = prodottiStorico.last;
          ultimoProdotto.luogoAcquisto = prodottoModificato.luogoAcquisto;
          ultimoProdotto.prezzoAcquisto = prodottoModificato.prezzoAcquisto;
        }
      }

      notifyListeners();
      saveProdottiDispensa();
      saveProdottiStorico();
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
    List<String>? jsonListDispensa = prefs.getStringList('prodottiDispensa');

    if (jsonListDispensa != null) {
      _prodottiDispensa = jsonListDispensa
          .map((json) => ProdottoDispensa.fromJson(jsonDecode(json)))
          .toList();
    }

    notifyListeners();
    loadProdottiStorico();
  }

  void rimuoviProdottiDeselezionati() {
    _prodottiDispensa.removeWhere((prodotto) => !prodotto.comprato);
    notifyListeners();
    saveProdottiDispensa();
  }

  void loadProdottiStorico() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonListStorico = prefs.getStringList('prodottiStorico');

    if (jsonListStorico != null) {
      prodottiStoricoMap = {};
      for (String json in jsonListStorico) {
        ProdottoDispensa prodotto = ProdottoDispensa.fromJson(jsonDecode(json));
        if (prodottiStoricoMap.containsKey(prodotto.descrizioneProdotto)) {
          prodottiStoricoMap[prodotto.descrizioneProdotto]!.add(prodotto);
        } else {
          prodottiStoricoMap[prodotto.descrizioneProdotto] = [prodotto];
        }
      }
    }

    notifyListeners();
  }

  void saveProdottiStorico() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = [];

    prodottiStoricoMap.forEach((descrizione, prodotti) {
      List<String> prodottiJsonList =
          prodotti.map((prodotto) => jsonEncode(prodotto.toJson())).toList();
      jsonList.addAll(prodottiJsonList);
    });

    await prefs.setStringList('prodottiStorico', jsonList);
  }
}
