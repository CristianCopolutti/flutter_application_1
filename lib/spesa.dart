import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/product.dart';
import 'package:flutter_application_1/shoppinglistprovider.dart';
import 'package:provider/provider.dart';

class SpesaScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SpesaScreenState();
}

class _SpesaScreenState extends State<SpesaScreen> {
  @override
  Widget build(BuildContext context) {
    final shoppingItemList = Provider.of<ShoppingListProvider>(context);
    final shoppingItems = shoppingItemList.listaProdottiSpesa;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista della Spesa'),
      ),
      body: ListView.builder(
        itemCount: shoppingItems.length + 1, // Add 1 for the header row
        itemBuilder: (context, index) {
          if (index == 0) {
            // Header row
            return Padding(
              padding: EdgeInsets.only(left: 16.0), // Add left padding
              child: DataTable(
                columnSpacing: 10.0,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('Prodotto'),
                  ),
                  DataColumn(
                    label: Text('Quantità'),
                  ),
                  DataColumn(
                    label: Text('Unità'),
                  ),
                  DataColumn(
                    label: Text(''),
                  ),
                ],
                rows: [],
              ),
            );
          }

          final item = shoppingItems[index - 1];

          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                shoppingItemList.removeProduct(index - 1);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Prodotto eliminato'),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        item.descrizioneProdotto,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: item.quantita,
                        onChanged: (value) {
                          setState(() {
                            item.quantita = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: DropdownButton<String>(
                        value: item.unita,
                        onChanged: (newValue) {
                          setState(() {
                            item.unita = newValue!;
                          });
                        },
                        items: <String>['', 'g', 'kg', 'l'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Checkbox(
                        value: item.comprato ?? false,
                        onChanged: (bool? newValue) {
                          setState(() {
                            item.comprato = newValue!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddItemScreen(aggiungiProdotto: (item) {
                shoppingItemList.aggiungiProdotto(item);
              }),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddItemScreen extends StatelessWidget {
  /*
    dichiaro una variabile aggiungiProdotto di tipo 'Function' che accetta parametro in ingresso di tipo Product;
    In questo caso, aggiungiProdotto è una callback o una funzione che può essere passata come argomento a un altro widget o componente.
    La variabile aggiungiProdotto viene utilizzata come parametro nel costruttore del widget AddItemScreen; permette di passare una funzione che verrà chiamata quando viene premuto il pulsante "Aggiungi".
  */

  final Function(Product) aggiungiProdotto;

  AddItemScreen({required this.aggiungiProdotto});

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aggiungi Prodotto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Prodotto'),
            ),
            ElevatedButton(
              onPressed: () {
                final String prodotto = _textController.text.trim();
                if (prodotto.isNotEmpty) {
                  aggiungiProdotto(Product(descrizioneProdotto: prodotto));
                }
                Navigator.pop(context);
              },
              child: Text('Aggiungi'),
            )
          ],
        ),
      ),
    );
  }
}
