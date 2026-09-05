import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storyteller_tactics/components/settings_dialog.dart';
import 'package:storyteller_tactics/data/cards_data.dart';
import 'package:storyteller_tactics/providers/settings_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('CardLanguage and Asset Paths', () {
    test('Language base paths are correct', () {
      expect(CardLanguage.english.basePath, 'asset/card/eng');
      expect(CardLanguage.indonesian.basePath, 'asset/card/ind');
      expect(CardLanguage.english.code, 'eng');
      expect(CardLanguage.indonesian.code, 'ind');
    });

    test('All cards resolve correctly for both English and Indonesian', () {
      expect(allCards.length, 53);

      for (final card in allCards) {
        final engPath = card.getImagePath(CardLanguage.english);
        final indPath = card.getImagePath(CardLanguage.indonesian);

        expect(engPath.startsWith('asset/card/eng/'), isTrue);
        expect(indPath.startsWith('asset/card/ind/'), isTrue);
        expect(engPath.substring('asset/card/eng/'.length),
            indPath.substring('asset/card/ind/'.length));
      }
    });

    test('TacticCard.imagePath reflects active language', () {
      final card = allCards.first;

      SettingsProvider.currentLanguage = CardLanguage.english;
      expect(card.imagePath, startsWith('asset/card/eng/'));

      SettingsProvider.currentLanguage = CardLanguage.indonesian;
      expect(card.imagePath, startsWith('asset/card/ind/'));
    });
  });

  group('SettingsProvider', () {
    test('Initializes with default English and updates language', () async {
      final provider = SettingsProvider();
      expect(provider.cardLanguage, CardLanguage.english);

      await provider.setCardLanguage(CardLanguage.indonesian);
      expect(provider.cardLanguage, CardLanguage.indonesian);
      expect(provider.getImagePath('01. Recipe/test.png'),
          'asset/card/ind/01. Recipe/test.png');

      await provider.setCardLanguage(CardLanguage.english);
      expect(provider.cardLanguage, CardLanguage.english);
      expect(provider.getImagePath('01. Recipe/test.png'),
          'asset/card/eng/01. Recipe/test.png');
    });

    test('Loads saved language preference from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'card_language_code': 'ind'});
      final provider = SettingsProvider();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(provider.cardLanguage, CardLanguage.indonesian);
    });
  });

  group('SettingsDialog Widget Test', () {
    testWidgets('Renders options and changes language on tap', (tester) async {
      final settingsProvider = SettingsProvider();

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<SettingsProvider>.value(
            value: settingsProvider,
            child: const Scaffold(
              body: SettingsDialog(),
            ),
          ),
        ),
      );

      // Verify UI texts
      expect(find.text('Pengaturan'), findsOneWidget);
      expect(find.text('Bahasa Gambar Kartu'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Indonesia'), findsOneWidget);

      // Tap on Indonesia
      await tester.tap(find.text('Indonesia'));
      await tester.pumpAndSettle();

      expect(settingsProvider.cardLanguage, CardLanguage.indonesian);

      // Tap on English
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(settingsProvider.cardLanguage, CardLanguage.english);
    });
  });
}
