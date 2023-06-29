import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottoDispensa.dart';
import 'package:flutter_application_1/prodottodispensaprovider.dart';
import 'package:flutter_application_1/prodottodispensaprovider.dart';
import 'package:flutter_application_1/product.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

class DispensaScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DispensaScreenState();
}

/*
class _DispensaScreenState: gestisce la schermata Dispensa
*/

class _DispensaScreenState extends State<DispensaScreen> {
  @override
  Widget build(BuildContext context) {
    /*
      creazione della lista prodottiDispensa fornita dal provider ProdottoDispensaProvider. In questo modo la lista che si va a formare nella schermata Dispensa si va a creare in modo dinamico.
    */
    final prodottiDispensa =
        Provider.of<ProdottoDispensaProvider>(context).prodottiDispensa;
    return Scaffold(
      appBar: AppBar(
        title: Text('DISPENSA'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: prodottiDispensa.length,
        itemBuilder: (context, index) {
          final item = prodottiDispensa[index];
          /*
            Creo una card per  ogni prodotto in dispensa;
            All'inizio la data di scadenza dei prodotti non è impostata;
            tramite la proprietà onTap --> _navigaModificaProdotto, mi permette di apportare le modifiche ad un prodotto in dispensa
          */
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
                _navigaModificaProdotto(context, item);
              },
            ),
          );
        },
      ),
      /*
        c'è anche la possibilità di aggiungere un prodotto manualmente nel caso in cui il prodotto non fosse stato inserito prima nella lista della spesa.
      */
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
                _salvaProdotto(context, nuovoProdotto);
                Navigator.pop(context);
              },
              child: Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }

  void _salvaProdotto(BuildContext context, ProdottoDispensa nuovoProdotto) {
    final prodottoDispensaProvider =
        Provider.of<ProdottoDispensaProvider>(context, listen: false);
    prodottoDispensaProvider.aggiungiProdotto(nuovoProdotto);
  }

  void _navigaModificaProdotto(
      BuildContext context, ProdottoDispensa prodotto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SchermataModificaProdotto(
          item: prodotto,
        ),
      ),
    );
  }
}

class SchermataModificaProdotto extends StatefulWidget {
  final ProdottoDispensa item;
  SchermataModificaProdotto({required this.item});

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
    _quantitaController.text = widget.item.quantita;
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
                  onPressed: () {
                    _salvaModifiche(context);
                  },
                  child: Text('Salva'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _eliminaProdotto(context);
                  },
                  child: Text('Elimina'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _salvaModifiche(BuildContext context) {
    final prodottoModificato = ProdottoDispensa(
      descrizioneProdotto: widget.item.descrizioneProdotto,
      dataScadenza: _dataScadenzaController.text,
      luogoAcquisto: _luogoAcquistoController.text,
      quantitaupdate: _quantitaController.text,
      prezzoAcquisto: _prezzoAcquistoController.text,
    );

    final prodottoDispensaProvider =
        Provider.of<ProdottoDispensaProvider>(context, listen: false);
    prodottoDispensaProvider.aggiornaProdotto(widget.item, prodottoModificato);
    Navigator.pop(context);
  }

  void _eliminaProdotto(BuildContext context) {
    final prodottoDispensaProvider =
        Provider.of<ProdottoDispensaProvider>(context, listen: false);
    prodottoDispensaProvider.rimuoviProdotto(widget.item.descrizioneProdotto);
  }
}
