import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottoDispensa.dart';
import 'package:flutter_application_1/prodottodispensaprovider.dart';
import 'package:provider/provider.dart';

class StoricoScreen extends StatefulWidget {
  const StoricoScreen({super.key});

  @override
  _StoricoScreenState createState() => _StoricoScreenState();
}

class _StoricoScreenState extends State<StoricoScreen> {
  String _termineRicerca = '';

  @override
  Widget build(BuildContext context) {
    final prodottiDispensaProvider =
        Provider.of<ProdottoDispensaProvider>(context);
    final prodottiStorico = prodottiDispensaProvider.prodottiStoricoMap;

    List<String> filteredKeys = prodottiStorico.keys
        .where(
            (key) => key.toLowerCase().contains(_termineRicerca.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('STORICO'),
        centerTitle: true,
      ),
      body: Column(
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
              itemCount: filteredKeys.length,
              itemBuilder: (context, index) {
                final prodottoKey = filteredKeys[index];
                final prodotti = prodottiStorico[prodottoKey]!;

                return SwipeToDismiss(
                  prodottoKey: prodottoKey,
                  onTap: () {
                    _mostraDettagliProdotto(context, prodotti);
                  },
                  onDismissed: (prodottoKey) {
                    prodottiDispensaProvider
                        .rimuoviProdottoStorico(prodottoKey);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Prodotto eliminato'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(prodottoKey),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _mostraDettagliProdotto(
      BuildContext context, List<ProdottoDispensa> prodotti) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(prodotti[0].descrizioneProdotto),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: prodotti.map((prodotto) {
                final luogoAcquisto = prodotto.luogoAcquisto ?? '';
                final prezzoAcquisto = prodotto.prezzoAcquisto ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (luogoAcquisto.isNotEmpty)
                      Text('Luogo Acquisto: $luogoAcquisto'),
                    if (prezzoAcquisto.isNotEmpty)
                      Text('Prezzo Acquisto: $prezzoAcquisto'),
                    const SizedBox(height: 8.0),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class SwipeToDismiss extends StatelessWidget {
  final String prodottoKey;
  final Widget child;
  final Function onTap;
  final Function(String) onDismissed;

  const SwipeToDismiss({
    super.key,
    required this.prodottoKey,
    required this.child,
    required this.onTap,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        onDismissed(prodottoKey);
      },
      child: GestureDetector(
        onTap: () => onTap(),
        child: child,
      ),
    );
  }
}
