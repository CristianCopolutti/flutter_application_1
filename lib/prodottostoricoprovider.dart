import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/prodottoDispensa.dart';
import 'package:flutter_application_1/prodottostorico.dart';
import 'package:flutter_application_1/prodottostoricoentry.dart';

class ProdottoStoricoProvider extends ChangeNotifier {
  List<ProdottoStorico> prodottiStorico = [];

  void aggiungiProdottoStorico(ProdottoDispensa prodottoDispensa) {
    late ProdottoStorico prodottoStorico;

    prodottoStorico = prodottiStorico.firstWhere(
      (p) => p.descrizioneProdotto == prodottoDispensa.descrizioneProdotto,
      orElse: () {
        prodottoStorico = null!;
        return prodottoStorico;
      },
    );

    if (prodottoStorico != null) {
      prodottoStorico.entry.add(
        ProdottoStoricoEntry(
          luogoAcquisto: prodottoDispensa.luogoAcquisto!,
          prezzoAcquisto: prodottoDispensa.prezzoAcquisto!,
        ),
      );
    } else {
      prodottiStorico.add(
        ProdottoStorico(
          descrizioneProdotto: prodottoDispensa.descrizioneProdotto,
          entry: [
            ProdottoStoricoEntry(
              luogoAcquisto: prodottoDispensa.luogoAcquisto!,
              prezzoAcquisto: prodottoDispensa.prezzoAcquisto!,
            ),
          ],
        ),
      );
    }
    notifyListeners();
  }
}
