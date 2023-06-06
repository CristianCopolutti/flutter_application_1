import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListaSpesaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista della Spesa'),
      ),
      body: Consumer<ListaSpesa>(
        builder: (context, listaSpesa, _) {
          return ListView.builder(
            itemCount: listaSpesa.prodotti.length,
            itemBuilder: (context, index) {
              final prodotto = listaSpesa.prodotti[index];
              return Dismissible(
                key: Key(prodotto.descrizione),
                onDismissed: (direction) {
                  listaSpesa.rimuoviProdotto(index);
                },
                child: ListTile(
                  title: Text(prodotto.descrizione),
                  subtitle: Text('Quantità: ${prodotto.quantita}'),
                  trailing: Checkbox(
                    value: prodotto.acquistato,
                    onChanged: (value) {
                      listaSpesa.setAcquistato(index, value ?? false);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final TextEditingController _descrizioneController =
                  TextEditingController();
              final TextEditingController _quantitaController =
                  TextEditingController();
              final TextEditingController _alternativaController =
                  TextEditingController();
              return AlertDialog(
                title: Text('Aggiungi Prodotto'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _descrizioneController,
                      decoration: InputDecoration(labelText: 'Descrizione'),
                    ),
                    TextField(
                      controller: _quantitaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Quantità'),
                    ),
                    Consumer<ListaSpesa>(
                      builder: (context, listaSpesa, _) {
                        return DropdownButton<String>(
                          itemHeight: null,
                          value: _alternativaController.text,
                          onChanged: (String? newValue) {
                            _alternativaController.text = newValue ?? '';
                          },
                          isExpanded: true,
                          items: listaSpesa.alternative
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text('Annulla'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Aggiungi'),
                    onPressed: () {
                      final nuovoProdotto = Prodotto(
                        descrizione: _descrizioneController.text,
                        quantita: int.tryParse(_quantitaController.text) ?? 0,
                        alternativa: _alternativaController.text,
                      );
                      final listaSpesa =
                          Provider.of<ListaSpesa>(context, listen: false);
                      listaSpesa.aggiungiProdotto(nuovoProdotto);

                      _descrizioneController.clear();
                      _quantitaController.clear();
                      _alternativaController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ListaSpesa with ChangeNotifier {
  List<Prodotto> prodotti = [];
  List<String> alternative = ['Opzione 1', 'Opzione 2', 'Opzione 3'];

  void aggiungiProdotto(Prodotto prodotto) {
    prodotti.add(prodotto);
    notifyListeners();
  }

  void rimuoviProdotto(int index) {
    prodotti.removeAt(index);
    notifyListeners();
  }

  void setAcquistato(int index, bool value) {
    prodotti[index].acquistato = value;
    notifyListeners();
  }
}

class Prodotto {
  String descrizione;
  int quantita;
  String alternativa;
  bool acquistato;

  Prodotto({
    required this.descrizione,
    required this.quantita,
    required this.alternativa,
    this.acquistato = false,
  });
}
