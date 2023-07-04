import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottostorico.dart';
import 'package:flutter_application_1/prodottostoricoprovider.dart';
import 'package:provider/provider.dart';

class StoricoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StoricoScreenState();
}

class _StoricoScreenState extends State<StoricoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Storico'),
        centerTitle: true,
      ),
      body: Consumer<ProdottoStoricoProvider>(
        builder: (context, prodottoStoricoProvider, _) {
          final prodottiStorico = prodottoStoricoProvider.prodottiStorico;
          return ListView.builder(
            itemCount: prodottiStorico.length,
            itemBuilder: (context, index) {
              final prodotto = prodottiStorico[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SchermataDettaglioProdotto(
                        prodotto: prodotto,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text(prodotto.descrizioneProdotto),
                    subtitle:
                        Text('Numero di acquisti: ${prodotto.entry.length}'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SchermataDettaglioProdotto extends StatelessWidget {
  final ProdottoStorico prodotto;

  SchermataDettaglioProdotto({required this.prodotto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettaglio Prodotto'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Descrizione: ${prodotto.descrizioneProdotto}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Acquisti:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: prodotto.entry.length,
              itemBuilder: (context, index) {
                final entry = prodotto.entry[index];
                return ListTile(
                  title: Text('Luogo: ${entry.luogoAcquisto}'),
                  subtitle: Text('Prezzo: ${entry.prezzoAcquisto}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
