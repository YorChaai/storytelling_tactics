import 'dart:math';
import 'package:flutter/foundation.dart';
import '../data/cards_data.dart';
import '../data/recipes_data.dart';

class GameSessionProvider with ChangeNotifier {
  List<TacticCard> _availableCards = [];
  List<TacticCard> _drawnCards = [];
  List<TacticCard> _latestDrawn = [];
  final List<Recipe> _customRecipes = [];

  List<TacticCard> get availableCards => _availableCards;
  List<TacticCard> get drawnCards => _drawnCards;
  List<TacticCard> get latestDrawn => _latestDrawn;
  List<Recipe> get customRecipes => _customRecipes;

  GameSessionProvider() {
    _initSession();
  }

  void _initSession() {
    // Clone all cards into available cards
    _availableCards = List.from(allCards);
    _drawnCards = [];
    _latestDrawn = [];
    notifyListeners();
  }

  void resetSession() {
    _initSession();
    // Note: customRecipes are deliberately not reset so they persist during the app lifecycle
  }

  void addCustomRecipe(Recipe recipe) {
    _customRecipes.add(recipe);
    notifyListeners();
  }

  void drawRandom(int count, {List<TacticCard>? subset}) {
    // If a subset is provided (e.g. Recipe or Desert Island), filter available cards
    // to only include those present in the subset.
    List<TacticCard> pool = _availableCards;
    
    if (subset != null) {
      final subsetIds = subset.map((c) => c.id).toSet();
      pool = _availableCards.where((c) => subsetIds.contains(c.id)).toList();
    }

    if (pool.isEmpty) return;

    final random = Random();
    final int toDraw = min(count, pool.length);
    
    // Create a mutable copy of the pool
    List<TacticCard> tempPool = List.from(pool);
    List<TacticCard> newlyDrawn = [];

    for (int i = 0; i < toDraw; i++) {
      int index = random.nextInt(tempPool.length);
      newlyDrawn.add(tempPool.removeAt(index));
    }

    // Add to drawn history and latest
    _latestDrawn = newlyDrawn;
    _drawnCards.addAll(newlyDrawn);

    // Remove from available
    final newlyDrawnIds = newlyDrawn.map((c) => c.id).toSet();
    _availableCards.removeWhere((c) => newlyDrawnIds.contains(c.id));

    notifyListeners();
  }

  void returnCards(List<TacticCard> cardsToReturn) {
    for (var card in cardsToReturn) {
      // Remove from drawn and latest drawn
      _drawnCards.removeWhere((c) => c.id == card.id);
      _latestDrawn.removeWhere((c) => c.id == card.id);
      
      // Add back to available cards if not already there
      if (!_availableCards.any((c) => c.id == card.id)) {
        _availableCards.add(card);
      }
    }
    notifyListeners();
  }

  // Draw without mutating the global session (used for Three Stories preview)
  // Wait, if it's Three Stories, we DO want to mutate so no duplicates occur across the 3 stories.
  // Actually the original spec didn't strictly say if Three Stories consumes from the deck, 
  // but "no duplicate card in one session" implies it should.
  List<TacticCard> drawSpecificNumber(int count, {List<TacticCard>? subset}) {
    List<TacticCard> pool = _availableCards;
    if (subset != null) {
      final subsetIds = subset.map((c) => c.id).toSet();
      pool = _availableCards.where((c) => subsetIds.contains(c.id)).toList();
    }

    if (pool.isEmpty) return [];

    final random = Random();
    final int toDraw = min(count, pool.length);
    
    List<TacticCard> tempPool = List.from(pool);
    List<TacticCard> newlyDrawn = [];

    for (int i = 0; i < toDraw; i++) {
      int index = random.nextInt(tempPool.length);
      newlyDrawn.add(tempPool.removeAt(index));
    }

    _drawnCards.addAll(newlyDrawn);
    final newlyDrawnIds = newlyDrawn.map((c) => c.id).toSet();
    _availableCards.removeWhere((c) => newlyDrawnIds.contains(c.id));

    notifyListeners();
    return newlyDrawn;
  }
}
