import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/product.dart';
import 'package:flutter_application_1/shoppinglistprovider.dart';
import 'package:provider/provider.dart';

class SpesaScreen extends StatefulWidget {
  @override
  /*
  in questo modo definisco il metodo createState(), il quale restituisce un'istanza di '_SpesaScreenState, la quale è l'oggetto di stato associato alla sottoclasse di 'StatefulWidget'.
  */
  State<StatefulWidget> createState() => _SpesaScreenState();
}

class _SpesaScreenState extends State<SpesaScreen> {
  @override
  Widget build(BuildContext context) {
    /*
    alla variabile shoppingItemList assegno l'istanza corrente di ShoppingListProvider. 
    */
    final shoppingItemList = Provider.of<ShoppingListProvider>(context);

    /*
    una volta ottenuta l'istanza di ShoppingListProvider è possibile accedere alle sue proprietà e metodi;
    ottengo tramite listaProdottiSpesa la lista dei prodotti;
    questa lista rappresenta i dati gestiti da ShoppingListProvider
    */

    final shoppingItems = shoppingItemList.listaProdottiSpesa;

    return Scaffold(
      appBar: AppBar(
        title: Text('LISTA DELLA SPESA'),
        centerTitle: true,
      ),
      /*
      Nel body inserisco una lista scrollabile;
      costruisce in modo dinamico gli elementi della lista
      */
      body: ListView.builder(
        itemCount: shoppingItems.length + 1,
        /*
        itemBuilder è una funzione di callback che viene richiamata per ogni elemento della lista
        */
        itemBuilder: (context, index) {
          if (index == 0) {
            // Header row
            return Padding(
              padding: EdgeInsets.only(left: 16.0),
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
              builder: (context) => AddItemScreen(
                aggiungiProdotto: (item) {
                  shoppingItemList.aggiungiProdotto(item);
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddItemScreen extends StatefulWidget {
  final Function(Product) aggiungiProdotto;

  AddItemScreen({required this.aggiungiProdotto});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _textController = TextEditingController();
  List<String> searchResults = [];

  Future<void> searchProduct(String productName) async {
    var url = Uri.parse(
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$productName&search_simple=1&action=process&json=1&lc=it&lc_products=it&');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = data['products'] as List<dynamic>;
      setState(() {
        searchResults = products
            .map((product) => product['product_name'] as String)
            .toList();
      });
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

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
              onChanged: (value) {
                searchProduct(value);
              },
              decoration: InputDecoration(labelText: 'Prodotto'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final productName = searchResults[index];
                  return ListTile(
                    title: Text(productName),
                    onTap: () {
                      widget.aggiungiProdotto(
                          Product(descrizioneProdotto: productName));
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final String productName = _textController.text.trim();
                if (productName.isNotEmpty) {
                  widget.aggiungiProdotto(
                      Product(descrizioneProdotto: productName));
                  Navigator.pop(context);
                }
              },
              child: Text('Aggiungi Manualmente'),
            ),
          ],
        ),
      ),
    );
  }
}
