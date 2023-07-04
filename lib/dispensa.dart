import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottoDispensa.dart';
import 'package:flutter_application_1/prodottodispensaprovider.dart';
import 'package:flutter_application_1/prodottodispensaprovider.dart';
import 'package:flutter_application_1/product.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class DispensaScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DispensaScreenState();
}

/*
class _DispensaScreenState: gestisce la schermata Dispensa
*/

class _DispensaScreenState extends State<DispensaScreen> {
  String _termineRicerca = '';
  @override
  Widget build(BuildContext context) {
    final prodottiDispensa =
        Provider.of<ProdottoDispensaProvider>(context).prodottiDispensa;
    return Scaffold(
      appBar: AppBar(
        title: Text('DISPENSA'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _mostraFiltro(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: false,
              onChanged: (value) {
                setState(() {
                  _termineRicerca = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Cerca prodotto',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: prodottiDispensa.length,
              itemBuilder: (context, index) {
                final item = prodottiDispensa[index];
                if (_termineRicerca.isNotEmpty &&
                    !item.descrizioneProdotto
                        .toLowerCase()
                        .contains(_termineRicerca.toLowerCase())) {
                  return SizedBox.shrink();
                }
                return Card(
                  child: ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              item.descrizioneProdotto,
                              style: TextStyle(fontWeight: FontWeight.bold),
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
                              )),
                        ],
                      ),
                      onTap: () {
                        _navigaModificaProdotto(context, item);
                      }),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _aggiungiProdotto(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _mostraFiltro(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Seleziona ordine di visualizzazione"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _applicaFiltro(context, 'asc');
                    Navigator.pop(context);
                  },
                  child: Text("Ordine crescente"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _applicaFiltro(context, 'desc');
                    Navigator.pop(context);
                  },
                  child: Text("Ordine decrescente"),
                ),
              ],
            ),
          );
        });
  }

  void _applicaFiltro(BuildContext context, String order) {
    final prodottiDispensa =
        Provider.of<ProdottoDispensaProvider>(context, listen: false);
    prodottiDispensa.ordinaProdottiPerScadenza(order);
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
  TextEditingController _luogoAcquistoController = TextEditingController();
  TextEditingController _quantitaController = TextEditingController();
  TextEditingController _prezzoAcquistoController = TextEditingController();
  TextEditingController _dataScadenzaController = TextEditingController();
  DateTime? _dataSelezionata;

  @override
  void initState() {
    super.initState();
    _luogoAcquistoController.text = widget.item.luogoAcquisto ?? '';
    _quantitaController.text = widget.item.quantitaupdate ?? '';
    _prezzoAcquistoController.text = widget.item.prezzoAcquisto ?? '';
    _dataScadenzaController.text = widget.item.dataScadenza ?? '';
  }

  Future<void> _selezionaData(BuildContext context) async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: _dataSelezionata ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (data != null && data != _dataSelezionata) {
      setState(() {
        _dataSelezionata = data;
        final dataFormattata = DateFormat('dd/MM/yyyy').format(data);
        _dataScadenzaController.text = dataFormattata;
      });
    }
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
              decoration: InputDecoration(
                  labelText: 'Data di scadenza',
                  prefixIcon: Icon(Icons.calendar_month_rounded)),
              onTap: () {
                _selezionaData(context);
              },
            ),
            TextFormField(
              controller: _luogoAcquistoController,
              decoration: InputDecoration(
                  labelText: 'Luogo di acquisto',
                  prefixIcon: Icon(Icons.local_mall)),
            ),
            TextFormField(
              controller: _quantitaController,
              decoration: InputDecoration(
                  labelText: 'Quantità', prefixIcon: Icon(Icons.numbers)),
            ),
            TextFormField(
              controller: _prezzoAcquistoController,
              decoration: InputDecoration(
                  labelText: 'Prezzo di acquisto',
                  prefixIcon: Icon(Icons.euro)),
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
