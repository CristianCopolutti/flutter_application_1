import 'package:flutter/material.dart';
/*
La classe Product serve per memorizzare i prodotti che l'utente inserisce manualmente all'interno della lista della spesa;
- descrizioneProdotto rappresenta il testo del prodotto
- quantita rappresenta la quantità desiderata dall'utente
- unita rappresenta la scelta tra vuoto, kg, g, l
- comprato serve per rappresentare la checkbox
*/

class Product {
  String descrizioneProdotto;
  String quantita;
  String unita;
  bool comprato;

  Product({
    required this.descrizioneProdotto,
    this.quantita = '',
    this.unita = '',
    this.comprato = false,
  });
}
