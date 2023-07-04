import 'package:flutter_application_1/product.dart';

/*
Questa classe serve per la gestione dei prodotti presenti nella dispensa
- dataScadenza --> visualizzazione della data di scadenza e gestione di essa
- luogoAcquisto --> serve per tenere traccia dove un prodotto è stato acquistato
- quantitaupdate --> serve per tenere traccia della quantità del prodotto nella dispensa
- prezzoAcquisto --> serve per tenere traccia del prezzo di acquisto di un prodotto
*/

class ProdottoDispensa extends Product {
  String? dataScadenza;
  String? luogoAcquisto;
  String? quantitaupdate;
  String? prezzoAcquisto;

  ProdottoDispensa({
    required String descrizioneProdotto,
    this.dataScadenza = '',
    this.luogoAcquisto,
    this.quantitaupdate,
    this.prezzoAcquisto,
  }) : super(descrizioneProdotto: descrizioneProdotto);

  factory ProdottoDispensa.fromJson(Map<String, dynamic> json) {
    return ProdottoDispensa(
      descrizioneProdotto: json['descrizioneProdotto'],
      dataScadenza: json['dataScadenza'],
      luogoAcquisto: json['luogoAcquisto'],
      quantitaupdate: json['quantitaupdate'],
      prezzoAcquisto: json['prezzoAcquisto'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'descrizioneProdotto': descrizioneProdotto,
      'dataScadenza': dataScadenza,
      'luogoAcquisto': luogoAcquisto,
      'quantitaupdate': quantitaupdate,
      'prezzoAcquisto': prezzoAcquisto,
    };
  }
}
