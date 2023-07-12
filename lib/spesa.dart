import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottoDispensa.dart';
import 'package:flutter_application_1/prodottodispensaprovider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/product.dart';
import 'package:flutter_application_1/shoppinglistprovider.dart';
import 'package:provider/provider.dart';

class SpesaScreen extends StatefulWidget {
  const SpesaScreen({super.key});

  @override
  /*
  in questo modo definisco il metodo createState(), il quale restituisce un'istanza di '_SpesaScreenState, la quale è l'oggetto di stato associato alla sottoclasse di 'StatefulWidget'.
  */
  State<StatefulWidget> createState() => _SpesaScreenState();
}

class _SpesaScreenState extends State<SpesaScreen> {
  bool _selezionatoTutto = false;

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

    final listaDispensa = Provider.of<ProdottoDispensaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LISTA DELLA SPESA'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _mostraScelte(shoppingItemList, listaDispensa);
            },
          ),
        ],
      ),
      body: shoppingItems.isEmpty
          ? const Center(
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vuoi acquistare qualcosa?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Clicca il pulsante + per aggiungere prodotti',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          /*
      Nel body inserisco una lista scrollabile;
      costruisce in modo dinamico gli elementi della lista
      */
          : ListView.builder(
              itemCount: shoppingItems.length + 1,
              /*
        itemBuilder è una funzione di callback che viene richiamata per ogni elemento della lista
        */
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Header row
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0),
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
                      rows: const [],
                    ),
                  );
                }

                final item = shoppingItems[index - 1];

                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    child: const Align(
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
                      const SnackBar(
                        content: Text('Prodotto eliminato'),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.descrizioneProdotto,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  initialValue: item.quantita,
                                  onChanged: (value) {
                                    item.quantita = value;
                                    shoppingItemList.saveShoppingList();
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: DropdownButton<String>(
                              value: item.unita,
                              onChanged: (newValue) {
                                setState(() {
                                  item.unita = newValue!;
                                  shoppingItemList.saveShoppingList();
                                });
                              },
                              items: <String>['', 'g', 'kg', 'l']
                                  .map((String value) {
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
                              value: item.comprato,
                              onChanged: (value) {
                                setState(() {
                                  item.comprato = value ?? false;
                                  shoppingItemList.setProdottoAcquistato(
                                      index - 1, value ?? false);
                                  aggiungiProdottoDispensa(context, item);
                                  shoppingItemList.saveShoppingList();
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
      floatingActionButton: SizedBox(
        width: 140,
        child: FloatingActionButton(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text('AGGIUNGI'),
            ],
          ),
        ),
      ),
    );
  }

  void _mostraScelte(ShoppingListProvider shoppingItemList,
      ProdottoDispensaProvider listaDispensa) async {
    final scelta = await showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(1000.0, 80.0, 0.0, 0.0),
        items: [
          const PopupMenuItem(
            value: 'selezionaTutto',
            child: Text('Seleziona tutto'),
          ),
          const PopupMenuItem(
            value: 'deselezionaTutto',
            child: Text('Deseleziona tutto'),
          ),
          const PopupMenuItem(
            value: 'eliminaTutto',
            child: Text('Elimina prodotti'),
          ),
        ]);
    if (scelta != null) {
      if (scelta == 'selezionaTutto') {
        setState(() {
          _selezionatoTutto = true;
          shoppingItemList.selezionaTutto();
        });
      } else if (scelta == 'deselezionaTutto') {
        setState(() {
          _selezionatoTutto = false;
          shoppingItemList.deselezionaTutto();
        });
        listaDispensa.rimuoviProdottiDeselezionati();
      } else if (scelta == 'eliminaTutto') {
        setState(() {
          _selezionatoTutto = false;
          shoppingItemList.rimuoviLista();
        });
      }
      if (_selezionatoTutto) {
        List<Product> prodottiSelezionati = shoppingItemList.listaProdottiSpesa
            .where((prodotto) => prodotto.comprato)
            .toList();
        for (Product prodotto in prodottiSelezionati) {
          ProdottoDispensa prodottoDispensa = ProdottoDispensa(
              descrizioneProdotto: prodotto.descrizioneProdotto);
          listaDispensa.aggiungiProdotto(context, prodottoDispensa);
        }
      }
    }
  }

  void aggiungiProdottoDispensa(BuildContext context, Product prodotto) {
    final prodottoDispensaProvider =
        Provider.of<ProdottoDispensaProvider>(context, listen: false);
    if (prodotto.comprato) {
      final prodottoDispensa =
          ProdottoDispensa(descrizioneProdotto: prodotto.descrizioneProdotto);
      prodottoDispensaProvider.aggiungiProdotto(context, prodottoDispensa);
    } else {
      prodottoDispensaProvider.rimuoviProdotto(prodotto.descrizioneProdotto);
    }
  }
}

class AddItemScreen extends StatefulWidget {
  final Function(Product) aggiungiProdotto;

  const AddItemScreen({Key? key, required this.aggiungiProdotto})
      : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _textController = TextEditingController();
  List<String> searchResults = [];
  bool isSearching = false;

  Future<void> searchProduct(String productName) async {
    setState(() {
      isSearching = true;
    });

    var url = Uri.parse(
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$productName&search_simple=1&action=process&json=1&lc=it&lc_products=it');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final products = data['products'] as List<dynamic>;
      setState(() {
        searchResults = products
            .map((product) => product['product_name'] as String)
            .toList();
        isSearching = false;
      });
    } else {
      setState(() {
        searchResults = [];
        isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aggiungi Prodotto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              onChanged: (value) {
                searchProduct(value);
              },
              decoration: const InputDecoration(labelText: 'Prodotto'),
            ),
            if (isSearching)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
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
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final String productName = _textController.text.trim();
                if (productName.isNotEmpty) {
                  widget.aggiungiProdotto(
                      Product(descrizioneProdotto: productName));
                  Navigator.pop(context);
                }
              },
              child: const Text('Aggiungi Manualmente'),
            ),
          ],
        ),
      ),
    );
  }
}
