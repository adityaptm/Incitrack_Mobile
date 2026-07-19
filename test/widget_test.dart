import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:incitrack_mobile/main.dart';
import 'package:incitrack_mobile/providers/auth_provider.dart';
import 'package:incitrack_mobile/providers/jalan_provider.dart';
import 'package:incitrack_mobile/providers/laporan_provider.dart';

void main() {
  testWidgets('App renders login screen successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => JalanProvider()),
          ChangeNotifierProvider(create: (_) => LaporanProvider()),
        ],
        child: const IncitrackApp(),
      ),
    );

    // Verifikasi bahwa widget SplashScreen atau LoginScreen dirender
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
