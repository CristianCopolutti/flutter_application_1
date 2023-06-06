class Product {
  String name;
  double quantita;
  String unit;
  bool comprato;

  Product(
      {required this.name,
      required this.quantita,
      required this.unit,
      this.comprato = false});
}
