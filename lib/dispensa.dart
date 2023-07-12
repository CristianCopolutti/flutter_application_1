import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottoDispensa.dart';
import 'package:flutter_application_1/prodottodispensaprovider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DispensaScreen extends StatefulWidget {
  const DispensaScreen({super.key});

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
        title: const Text('DISPENSA'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _mostraFiltro(context);
            },
          ),
        ],
      ),
      body: prodottiDispensa.isEmpty
          ? const Center(
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Inserisci il tuo prodotto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Clicca il pulsante + per aggiungere prodotti oppure spunta un prodotto presente nella tua lista della spesa per inserirlo in dispensa',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                        ),
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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TextField(
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        _termineRicerca = value;
                      });
                    },
                    decoration: const InputDecoration(
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
                        return const SizedBox.shrink();
                      }
                      return Card(
                        child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item.descrizioneProdotto,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      item.dataScadenza ?? 'N/A',
                                      style: const TextStyle(
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
      floatingActionButton: SizedBox(
        width: 140,
        child: FloatingActionButton(
          onPressed: () {
            _aggiungiProdotto(context);
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

  void _mostraFiltro(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Seleziona ordine di visualizzazione"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _applicaFiltro(context, 'asc');
                    Navigator.pop(context);
                  },
                  child: const Text("Ordine crescente"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _applicaFiltro(context, 'desc');
                    Navigator.pop(context);
                  },
                  child: const Text("Ordine decrescente"),
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
        TextEditingController descrizioneController = TextEditingController();
        return AlertDialog(
          title: const Text('Aggiungi prodotto'),
          content: TextFormField(
            controller: descrizioneController,
            decoration: const InputDecoration(labelText: 'Descrizione'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                final nuovoProdotto = ProdottoDispensa(
                  descrizioneProdotto: descrizioneController.text,
                );
                _salvaProdotto(context, nuovoProdotto);
                Navigator.pop(context);
              },
              child: const Text('Aggiungi'),
            ),
          ],
        );
      },
    );
  }

  void _salvaProdotto(BuildContext context, ProdottoDispensa nuovoProdotto) {
    final prodottoDispensaProvider =
        Provider.of<ProdottoDispensaProvider>(context, listen: false);
    prodottoDispensaProvider.aggiungiProdotto(context, nuovoProdotto);
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
  const SchermataModificaProdotto({super.key, required this.item});

  @override
  _SchermataModificaProdottoState createState() =>
      _SchermataModificaProdottoState();
}

class _SchermataModificaProdottoState extends State<SchermataModificaProdotto> {
  final TextEditingController _luogoAcquistoController =
      TextEditingController();
  final TextEditingController _quantitaController = TextEditingController();
  final TextEditingController _prezzoAcquistoController =
      TextEditingController();
  final TextEditingController _dataScadenzaController = TextEditingController();
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
        title: const Text('Modifica Prodotto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Descrizione: ${widget.item.descrizioneProdotto}'),
            TextFormField(
              controller: _dataScadenzaController,
              decoration: const InputDecoration(
                  labelText: 'Data di scadenza',
                  prefixIcon: Icon(Icons.calendar_month_rounded)),
              onTap: () {
                _selezionaData(context);
              },
            ),
            TextFormField(
              controller: _luogoAcquistoController,
              decoration: const InputDecoration(
                  labelText: 'Luogo di acquisto',
                  prefixIcon: Icon(Icons.local_mall)),
            ),
            TextFormField(
              controller: _quantitaController,
              decoration: const InputDecoration(
                  labelText: 'Quantità', prefixIcon: Icon(Icons.numbers)),
            ),
            TextFormField(
              controller: _prezzoAcquistoController,
              decoration: const InputDecoration(
                  labelText: 'Prezzo di acquisto',
                  prefixIcon: Icon(Icons.euro)),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _salvaModifiche(context);
                  },
                  child: const Text('Salva'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _eliminaProdotto(context, widget.item);
                    Navigator.pop(context);
                  },
                  child: const Text('Elimina'),
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

  void _eliminaProdotto(BuildContext context, ProdottoDispensa prodotto) {
    final prodottoDispensaProvider =
        Provider.of<ProdottoDispensaProvider>(context, listen: false);
    prodottoDispensaProvider.rimuoviProdottoDispensa(prodotto);
  }
}
