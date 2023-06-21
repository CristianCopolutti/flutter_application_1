import 'package:flutter_application_1/product.dart';

class ProdottoDispensa extends Product {
  String? dataScadenza;
  String? luogoAcquisto;
  String? quantitaupdate;
  String? prezzoAcquisto;

  ProdottoDispensa({
    required String descrizioneProdotto,
    this.dataScadenza,
    this.luogoAcquisto,
    this.quantitaupdate,
    this.prezzoAcquisto,
  }) : super(descrizioneProdotto: descrizioneProdotto);
}
