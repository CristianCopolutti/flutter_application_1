import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottodispensaprovider.dart';
import 'package:flutter_application_1/shoppinglistprovider.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shoppingItemList = Provider.of<ShoppingListProvider>(context);
    final shoppingItems = shoppingItemList.listaProdottiSpesa;

    final listaProdottiDispensa =
        Provider.of<ProdottoDispensaProvider>(context);
    final listaDispensa = listaProdottiDispensa.prodottiDispensa;

    MyHomePageState? state = context.findAncestorStateOfType<MyHomePageState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                state?.onItemTap(1);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                height: MediaQuery.of(context).size.height * 0.3,
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Prodotti nella lista della spesa",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Expanded(
                          child: ListView.builder(
                            itemCount: shoppingItems.length,
                            itemBuilder: (context, index) {
                              final item = shoppingItems[index];
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text(
                                          item.descrizioneProdotto,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: 12.0),
                                      Text(
                                        "Quantità:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 4.0),
                                      Text(
                                        "${item.quantita}",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 2.0),
                                      Text(
                                        item.unita,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.0),
                                  Divider(),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                state?.onItemTap(2);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                height: MediaQuery.of(context).size.height * 0.3,
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Prodotti nella dispensa",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: listaDispensa.length,
                            itemBuilder: (context, index) {
                              final item = listaDispensa[index];
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text(
                                          item.descrizioneProdotto,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.0,
                                            color: Colors.black,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: 12.0),
                                      Text(
                                        "Scadenza",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 4.0),
                                      Text(
                                        "${item.dataScadenza}",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.0),
                                  Divider(),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
