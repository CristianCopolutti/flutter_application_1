import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottoDispensa.dart';
import 'package:flutter_application_1/product.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class DispensaScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DispensaScreenState();
}

class _DispensaScreenState extends State<DispensaScreen> {
  List<ProdottoDispensa> prodottiDispensa = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DISPENSA'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: prodottiDispensa.length,
        itemBuilder: (context, index) {
          final item = prodottiDispensa[index];
          return Card(
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
                    flex: 2,
                    child: Text(
                      item.dataScadenza ?? 'N/A',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                _NavigazioneModificaProdotto(item);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _aggiungiProdotto(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _aggiungiProdotto(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _descrizioneController = TextEditingController();
        return AlertDialog(
          title: Text('Aggiungi prodotto'),
          content: TextFormField(
            controller: _descrizioneController,
            decoration: InputDecoration(labelText: 'Descrizione'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                final nuovoProdotto = ProdottoDispensa(
                  descrizioneProdotto: _descrizioneController.text,
                );
                _salvaProdotto(nuovoProdotto);
                Navigator.pop(context);
              },
              child: Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }

  void _salvaProdotto(ProdottoDispensa nuovoProdotto) {
    setState(() {
      prodottiDispensa.add(nuovoProdotto);
    });
  }

  void _NavigazioneModificaProdotto(ProdottoDispensa prodotto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SchermataModificaProdotto(
          item: prodotto,
          salva: (elementoModificato) {
            _aggiornaElemento(prodotto, elementoModificato);
          },
          elimina: () {
            _cancellaElemento(prodotto);
          },
        ),
      ),
    );
  }

  void _aggiornaElemento(
      ProdottoDispensa vecchioProdotto, ProdottoDispensa nuovoProdotto) {
    setState(() {
      final index = prodottiDispensa.indexOf(vecchioProdotto);
      prodottiDispensa[index] = nuovoProdotto;
    });
  }

  void _cancellaElemento(ProdottoDispensa prodotto) {
    setState(() {
      prodottiDispensa.remove(prodotto);
    });
  }
}

class SchermataModificaProdotto extends StatefulWidget {
  final ProdottoDispensa item;
  final Function(ProdottoDispensa) salva;
  final Function elimina;

  SchermataModificaProdotto(
      {required this.item, required this.salva, required this.elimina});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
