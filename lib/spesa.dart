import 'package:flutter/material.dart';
import 'package:flutter_application_1/product.dart';
import 'package:flutter_application_1/shoppinglistprovider.dart';
import 'package:provider/provider.dart';

class SpesaScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SpesaScreenState();
}

class _SpesaScreenState extends State<SpesaScreen> {
/*classe che viene utilizzata per gestire e controllare il testo in un widget 'TextField' o 'TextFormField'; questa classe fornisce metodi per accedere e modificare il testo all'interno del campo di testo
*/
  TextEditingController nomeController = TextEditingController();
  TextEditingController quantitaController = TextEditingController();

  String unitaSelezionata = '';

  void aggiungiProdotto() {
    String nome = nomeController.text;
    double quantita = double.parse(quantitaController.text);

    if (nome.isNotEmpty && quantita > 0 && unitaSelezionata.isNotEmpty) {
      Product nuovoProdotto =
          Product(nome: nome, quantita: quantita, unit: unitaSelezionata);

      //aggiunge un nuovo prodotto inerente al contesto attualmente in uso
      Provider.of<ShoppingListProvider>(context, listen: false)
          .aggiungiProdotto(nuovoProdotto);

      nomeController.clear(); //metodo utilizzato per cancellare il testo
      quantitaController.clear();
      unitaSelezionata = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    //BuildContext context --> contesto corrente in cui viene costruito il widget; il metodo build deve restituire un widget che rappresenta la rappresentazione visuale del widget corrente
    return Scaffold(
      //fornisce struttura di base
      appBar: AppBar(
        title: Text('Lista della spesa'),
        centerTitle: true,
      ),
      //body --> corpo principale dell'applicazione, contiene contenuto principale come testo, immagini, elenchi o altri widget
      /* column: widget che consente di organizzare i suoi widget figlio in una colonna verticale, uno sopra l'altro; utile quando si vuole impilare widget verticalmente all'interno di un layout
      */
      body: Column(
        /*children viene utilizzato per definire un elenco di widget figlio da visualizzare o posizionare all'interno del widget padre; accetta un elenco di widget come valore
        */
        children: [
          /*
          widget Padding utilizzato per aggiungere spaziatura interna ai suoi widget figlio; consente di impostare uno spazio vuoto uniforme o specifico sui 4 lati dei widget figlio
          */
          Padding(
            padding: EdgeInsets.all(10.0),
            /*
            widget row viene utilizzato per organizzare i widget figlio in una riga orizzontale, allineandoli uno accanto all'altro
            */
            child: Row(
              children: [
                /*
                widget expanded --> utilizzato per definire un widget che si espande per occupare lo spazio disponibile all'interno del widget genitore.
                Il widget all'interno di expanded si espanderà o si contrarrà a seconda dello spazio disponibile
                */
                Expanded(
                    child: TextField(
                  controller: nomeController,
                  decoration: InputDecoration(labelText: 'Nome prodotto'),
                )),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    child: TextField(
                  controller: quantitaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Quantità'),
                )),
                SizedBox(
                  width: 10.0,
                ),
                /*
                dropdownButton utilizzato per creare un menu a tendina
                L'elenco delle opzioni è fornito attraverso la proprietà items che contiene un elenco di widget DropdownMenuItem.
                */
                DropdownButton<String>(
                  value: unitaSelezionata,
                  onChanged: (String? nuovoValore) {
                    setState(() {
                      unitaSelezionata = nuovoValore!;
                    });
                  },
                  items: <String>['', 'g', 'kg', 'l']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('value'),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: aggiungiProdotto,
                  child: Text('Aggiungi'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ShoppingListProvider>(
              builder: (context, provider, _) {
                /*
                ListView.builder è un widget che permette di creare una vista di un elenco scorrevole con contenuto dinamico; 
                Richiede parametro 'builder', che è una funzione di callback che costruisce gli elementi individuali dell'elenco in modo dinamico.
                */
                return Scrollbar(
                  child: ListView.builder(
                    itemCount: provider.listaProdottiSpesa.length,
                    /*
                    la funzione itemBuilder si occupa di costruire ogni singolo elemento; viene chiamata per ciascun elemento nell'intervallo degli elementi visibili
                    */
                    itemBuilder: (context, index) {
                      final prodotto = provider.listaProdottiSpesa[index];
                      /*
                      la funzione Dismissible permette di aggiungere una funzione di 'dismiss' a un altro widget; consente all'utente di trascinare o fare uno swipe su un elemento per rimuoverlo dalla vista.
                      */
                      return Dismissible(
                        //la chiave identifica in modo univoco l'elemento
                        key: Key(prodotto.nome),
                        /*
                          Il widget container serve per modificare la presentazione di altri widget; serve per fornire un rettangolo visivo
                        */
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        /*
                        Imposto la direzione dello swap; in questo caso dalla fine all'inizio
                        */
                        direction: DismissDirection.endToStart,
                        /*
                        onDismissed: di solito è una funzione che viene utilizzata per gestire il comportamento quando l'elemento viene rimosso
                        */
                        onDismissed: (direction) {
                          provider.removeProduct(index);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Prodotto eliminato'),
                            ),
                          );
                        },
                        /*
                        ListTile è un widget che rappresenta un elemento di un elenco; 
                        */
                        child: ListTile(
                          title: Text(
                              '${prodotto.nome} ${prodotto.quantita.toStringAsFixed(2)} ${prodotto.unit}'),
                          trailing: Checkbox(
                            value: prodotto.comprato,
                            onChanged: (bool? nuovoValore) {
                              setState(() {
                                prodotto.comprato = nuovoValore!;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
