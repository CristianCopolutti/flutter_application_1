import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottoDispensa.dart';
import 'package:flutter_application_1/prodottodispensaprovider.dart';
import 'package:provider/provider.dart';

class StoricoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prodottiDispensaProvider =
        Provider.of<ProdottoDispensaProvider>(context);
    final prodottiStorico = prodottiDispensaProvider.prodottiStoricoMap;

    return Scaffold(
      appBar: AppBar(
        title: Text('Storico'),
      ),
      body: ListView.builder(
        itemCount: prodottiStorico.length,
        itemBuilder: (context, index) {
          final keys = prodottiStorico.keys.toList();
          final prodottoKey = keys[index];
          final prodotti = prodottiStorico[prodottoKey]!;

          return SwipeToDismiss(
            prodottoKey: prodottoKey,
            onTap: () {
              _mostraDettagliProdotto(context, prodotti);
            },
            onDismissed: (prodottoKey) {
              if (prodottoKey != null) {
                prodottiDispensaProvider.rimuoviProdottoStorico(prodottoKey);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Prodotto eliminato'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Card(
              child: ListTile(
                title: Text(prodottoKey),
              ),
            ),
          );
        },
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Luogo Acquisto: ${prodotto.luogoAcquisto ?? ''}'),
                    Text('Prezzo Acquisto: ${prodotto.prezzoAcquisto ?? ''}'),
                    SizedBox(height: 8.0),
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
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Icon(
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
