import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CardLanguage {
  english(
    displayName: 'English',
    code: 'eng',
    basePath: 'asset/card/eng',
    flag: '🇬🇧',
  ),
  indonesian(
    displayName: 'Indonesia',
    code: 'ind',
    basePath: 'asset/card/ind',
    flag: '🇮🇩',
  );

  final String displayName;
  final String code;
  final String basePath;
  final String flag;

  const CardLanguage({
    required this.displayName,
    required this.code,
    required this.basePath,
    required this.flag,
  });

  static CardLanguage fromCode(String? code) {
    if (code == 'ind') return CardLanguage.indonesian;
    return CardLanguage.english;
  }
}

class SettingsProvider extends ChangeNotifier {
  static const String _prefKeyLanguage = 'card_language_code';

  static CardLanguage currentLanguage = CardLanguage.english;

  CardLanguage _cardLanguage = CardLanguage.english;
  bool _isLoaded = false;

  SettingsProvider() {
    _loadSettings();
  }

  CardLanguage get cardLanguage => _cardLanguage;
  bool get isLoaded => _isLoaded;

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_prefKeyLanguage);
      if (savedCode != null) {
        _cardLanguage = CardLanguage.fromCode(savedCode);
        currentLanguage = _cardLanguage;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> setCardLanguage(CardLanguage language) async {
    if (_cardLanguage == language) return;

    _cardLanguage = language;
    currentLanguage = language;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKeyLanguage, language.code);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  String getImagePath(String relativePath) {
    return '${_cardLanguage.basePath}/$relativePath';
  }
}
