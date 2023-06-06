import 'package:flutter/material.dart';
import 'package:flutter_application_1/product.dart';
import 'package:flutter_application_1/shoppinglistprovider.dart';
import 'package:provider/provider.dart';

class SpesaScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SpesaScreenState();
}

class _SpesaScreenState extends State<SpesaScreen>{

/*classe che viene utilizzata per gestire e controllare il testo in un widget 'TextField' o 'TextFormField'; questa classe fornisce metodi per accedere e modificare il testo all'interno del campo di testo
*/
  TextEditingController nomeController = TextEditingController();
  TextEditingController quantitaController = TextEditingController();

  String unitaSelezionata = '';

  void aggiungiProdotto(){
    String nome = nomeController.text;
    double quantita = double.parse(quantitaController.text);

    if (nome.isNotEmpty && quantita > 0 && unitaSelezionata.isNotEmpty){
      Product nuovoProdotto = Product(name: nome, quantita: quantita, unit: unitaSelezionata);

    //aggiunge un nuovo prodotto inerente al contesto attualmente in uso
      Provider.of<ShoppingListProvider>(context, listen: false).aggiungiProdotto(nuovoProdotto);

      nomeController.clear();  //metodo utilizzato per cancellare il testo
      quantitaController.clear();
      unitaSelezionata = '';
    }

  }

  @override
  Widget build(BuildContext context) { //BuildContext context --> contesto corrente in cui viene costruito il widget; il metodo build deve restituire un widget che rappresenta la rappresentazione visuale del widget corrente
    return Scaffold( //fornisce struttura di base
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
                
                */
                DropdownButton<String>(
                  value: unitaSelezionata, 
                  onChanged: (String? nuovoValore){
                    setState(() {
                      unitaSelezionata = nuovoValore!;
                    });
                  },
                  items: [],)
              ],
            ),
          )
        ],
      ),
    )
  }

}
