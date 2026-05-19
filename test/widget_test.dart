import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// Pastikan path import ini benar sesuai nama project Anda
import 'package:mdi/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // 1. Build aplikasi kita.
    // Karena MyApp() di main.dart tidak wajib menerima parameter (semua sudah di-handle internal),
    // pastikan tidak ada typo pada nama class.
    await tester.pumpWidget(const MyApp());

    // 2. Tunggu hingga SplashScreen selesai merender (opsional tapi disarankan)
    await tester.pumpAndSettle();

    // 3. Verifikasi apakah ExploreLearnApp terpasang
    expect(find.byType(MyApp), findsOneWidget);
  });
}
