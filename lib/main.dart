import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottodispensaprovider.dart';
import 'package:flutter_application_1/shoppinglistprovider.dart';
import 'package:flutter_application_1/storico.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'dispensa.dart';
import 'spesa.dart';
import 'notification_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShoppingListProvider()),
        ChangeNotifierProvider(
          create: (_) => ProdottoDispensaProvider()..loadProdottiDispensa(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("it", "IT"),
      ],
      debugShowCheckedModeBanner: false,
      title: 'SaveFood',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  PageController pageController = PageController();
  List<Widget> pages = [
    const HomePage(),
    const SpesaScreen(),
    const DispensaScreen(),
    const StoricoScreen(),
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    NotificationService.initializeNotification(context);
  }

  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void onItemTap(int selectedItem) {
    pageController.jumpToPage(selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onItemTap,
        currentIndex: selectedIndex,
        items: const [
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
