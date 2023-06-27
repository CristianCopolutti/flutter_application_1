import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottoDispensa.dart';
import 'package:flutter_application_1/prodottodispensaprovider.dart';
import 'package:flutter_application_1/product.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class DispensaScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DispensaScreenState();
}

class _DispensaScreenState extends State<DispensaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DISPENSA'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: ProdottoDispensaProvider.prodottiDispensa.length,
        itemBuilder: (context, index) {
          final item = ProdottoDispensaProvider.prodottiDispensa[index];
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
      ProdottoDispensaProvider.prodottiDispensa.add(nuovoProdotto);
    });
  }

  void _NavigazioneModificaProdotto(ProdottoDispensa prodotto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SchermataModificaProdotto(
          item: prodotto,
          onSave: (elementoModificato) {
            _aggiornaElemento(prodotto, elementoModificato);
            if (elementoModificato.comprato) {
              _aggiungiProdottoDispensa(elementoModificato);
            } else {
              _rimuoviProdottoDispensa(elementoModificato);
            }
          },
          onDelete: () {
            _cancellaElemento(prodotto);
          },
        ),
      ),
    );
  }

  void _aggiungiProdottoDispensa(ProdottoDispensa prodotto) {
    setState(() {
      ProdottoDispensaProvider.prodottiDispensa.add(prodotto);
    });
  }

  void _rimuoviProdottoDispensa(ProdottoDispensa prodotto) {
    setState(() {
      ProdottoDispensaProvider.prodottiDispensa.remove(prodotto);
    });
  }

  void _aggiornaElemento(
      ProdottoDispensa vecchioProdotto, ProdottoDispensa nuovoProdotto) {
    setState(() {
      final index =
          ProdottoDispensaProvider.prodottiDispensa.indexOf(vecchioProdotto);
      ProdottoDispensaProvider.prodottiDispensa[index] = nuovoProdotto;
    });
  }

  void _cancellaElemento(ProdottoDispensa prodotto) {
    setState(() {
      ProdottoDispensaProvider.prodottiDispensa.remove(prodotto);
    });
  }
}

class SchermataModificaProdotto extends StatefulWidget {
  final ProdottoDispensa item;
  final Function(ProdottoDispensa) onSave;
  final Function() onDelete;

  SchermataModificaProdotto(
      {required this.item, required this.onSave, required this.onDelete});

  @override
  _SchermataModificaProdottoState createState() =>
      _SchermataModificaProdottoState();
}

class _SchermataModificaProdottoState extends State<SchermataModificaProdotto> {
  TextEditingController _dataScadenzaController = TextEditingController();
  TextEditingController _luogoAcquistoController = TextEditingController();
  TextEditingController _quantitaController = TextEditingController();
  TextEditingController _prezzoAcquistoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataScadenzaController.text = widget.item.dataScadenza ?? '';
    _luogoAcquistoController.text = widget.item.luogoAcquisto ?? '';
    _quantitaController.text = widget.item.quantitaupdate ?? '';
    _prezzoAcquistoController.text = widget.item.prezzoAcquisto ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifica Prodotto'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Descrizione: ${widget.item.descrizioneProdotto}'),
            TextFormField(
              controller: _dataScadenzaController,
              decoration: InputDecoration(labelText: 'Data di scadenza'),
            ),
            TextFormField(
              controller: _luogoAcquistoController,
              decoration: InputDecoration(labelText: 'Luogo di acquisto'),
            ),
            TextFormField(
              controller: _quantitaController,
              decoration: InputDecoration(labelText: 'Quantità'),
            ),
            TextFormField(
              controller: _prezzoAcquistoController,
              decoration: InputDecoration(labelText: 'Prezzo di acquisto'),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _salvaModifiche,
                  child: Text('Salva'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onDelete();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Annulla'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _salvaModifiche() {
    final elementoModificato = ProdottoDispensa(
      descrizioneProdotto: widget.item.descrizioneProdotto,
      dataScadenza: _dataScadenzaController.text,
      luogoAcquisto: _luogoAcquistoController.text,
      quantitaupdate: _quantitaController.text,
      prezzoAcquisto: _prezzoAcquistoController.text,
    );
    widget.onSave(elementoModificato);
    Navigator.pop(context);
  }
}
