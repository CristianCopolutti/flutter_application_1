class Product {
  String nome;
  double quantita;
  String unit;
  bool comprato;

  Product(
      {required this.nome,
      required this.quantita,
      required this.unit,
      this.comprato = false});
}
