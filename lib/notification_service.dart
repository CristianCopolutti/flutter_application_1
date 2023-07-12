import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/prodottodispensaprovider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static Future<void> initializeNotification(BuildContext context) async {
    final prodottoDispensaProvider =
        Provider.of<ProdottoDispensaProvider>(context, listen: false);
    await prodottoDispensaProvider.loadProdottiDispensa();

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          // Richiedi l'autorizzazione per inviare notifiche
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    final prodottiDispensa = prodottoDispensaProvider.prodottiDispensa;

    if (prodottiDispensa.isEmpty) {
      // If there are no products in the pantry, do not create the notification
      return;
    }

    final now = DateTime.now();
    final expirationThreshold = now.add(const Duration(days: 4));

    // Find the products that will expire within the next 4 days, including today
    final prodottiScadenzaProssima = prodottiDispensa.where((prodotto) {
      if (prodotto.dataScadenza == null || prodotto.dataScadenza!.isEmpty) {
        // Il prodotto non ha una data di scadenza, saltalo
        return false;
      }

      final dataScadenza =
          DateFormat('dd/MM/yyyy').parse(prodotto.dataScadenza!);

      // Exclude expired products
      if (dataScadenza.isBefore(now) &&
          !(dataScadenza.day == now.day &&
              dataScadenza.month == now.month &&
              dataScadenza.year == now.year)) {
        return false;
      }

      // Include products that will expire within the next 4 days, including today
      return dataScadenza.isBefore(expirationThreshold);
    }).toList();

    if (prodottiScadenzaProssima.isEmpty) {
      // If there are no products near the expiration date, do not create the notification
      return;
    }

    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'high_importance_channel',
          channelName: 'Notifiche Prodotti',
          channelDescription: 'Channel Description',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          playSound: true,
          onlyAlertOnce: true,
          enableVibration: true,
          importance: NotificationImportance.Max,
          criticalAlerts: true,
        ),
      ],
      debug: true,
    );

    prodottiScadenzaProssima.sort((a, b) {
      final dataScadenzaA = DateFormat('dd/MM/yyyy').parse(a.dataScadenza!);
      final dataScadenzaB = DateFormat('dd/MM/yyyy').parse(b.dataScadenza!);
      return dataScadenzaA.compareTo(dataScadenzaB);
    });

    String notificationBody = '';
    final lastIndex = prodottiScadenzaProssima.length - 1;

    for (int i = 0; i < prodottiScadenzaProssima.length; i++) {
      final prodotto = prodottiScadenzaProssima[i];
      final dataScadenza =
          DateFormat('dd/MM/yyyy').parse(prodotto.dataScadenza!);
      final giorniMancanti =
          dataScadenza.difference(now.subtract(const Duration(days: 1))).inDays;

      notificationBody +=
          '${prodotto.descrizioneProdotto}: ($giorniMancanti gg)';

      if (i != lastIndex) {
        notificationBody += ', ';
      }
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'high_importance_channel',
        title: 'SCADENZA PRODOTTI NEI PROSSIMI 4 GIORNI',
        body: notificationBody,
      ),
    );

    // Check for expired products
    final prodottiScaduti = prodottiDispensa.where((prodotto) {
      if (prodotto.dataScadenza == null || prodotto.dataScadenza!.isEmpty) {
        // Il prodotto non ha una data di scadenza, saltalo
        return false;
      }

      final dataScadenza =
          DateFormat('dd/MM/yyyy').parse(prodotto.dataScadenza!);

      return dataScadenza.isBefore(now) &&
          !(dataScadenza.day == now.day &&
              dataScadenza.month == now.month &&
              dataScadenza.year == now.year);
    }).toList();

    if (prodottiScaduti.isNotEmpty) {
      prodottiScaduti.sort((a, b) {
        final dataScadenzaA = DateFormat('dd/MM/yyyy').parse(a.dataScadenza!);
        final dataScadenzaB = DateFormat('dd/MM/yyyy').parse(b.dataScadenza!);
        return dataScadenzaA.compareTo(dataScadenzaB);
      });

      String expiredProductsBody = '';
      for (int i = 0; i < prodottiScaduti.length; i++) {
        expiredProductsBody += prodottiScaduti[i].descrizioneProdotto;
        if (i < prodottiScaduti.length - 1) {
          expiredProductsBody += ', ';
        }
      }

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'high_importance_channel',
          title: 'PRODOTTI SCADUTI',
          body: expiredProductsBody,
        ),
      );
    }
  }
}
