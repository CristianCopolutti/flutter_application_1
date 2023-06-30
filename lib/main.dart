import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottodispensaprovider.dart';
import 'package:flutter_application_1/shoppinglistprovider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'dispensa.dart';
import 'spesa.dart';
import 'storico.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()),
        ChangeNotifierProvider(create: (_) => ProdottoDispensaProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("it", "IT"),
      ],
      debugShowCheckedModeBanner: false,
      title: 'MiaApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State {
  PageController pageController = PageController();
  List<Widget> pages = [HomePage(), SpesaScreen(), DispensaScreen(), Storico()];

  int selectIndex = 0;

  void onPageChanged(int index) {
    setState(() {
      selectIndex = index;
    });
  }

  void onItemTap(int selectedItems) {
    pageController.jumpToPage(selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: pages,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onItemTap,
        currentIndex: selectIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Spesa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: "Dispensa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage_rounded),
            label: "Storico",
          ),
        ],
      ),
    );
  }
}
