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
