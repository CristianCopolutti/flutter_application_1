import 'package:flutter/material.dart';
import 'package:flutter_application_1/product.dart';
import 'package:flutter_application_1/shoppinglistprovider.dart';
import 'package:provider/provider.dart';

class SpesaScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SpesaScreenState();
}

class _SpesaScreenState extend State<SpesaScreen>{

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
      /* column: widget 
      body: Column(
        children: [],
      ),
    )
  }

}
