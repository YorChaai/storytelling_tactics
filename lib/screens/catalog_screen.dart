import 'package:flutter/material.dart';
import '../data/cards_data.dart';
import '../components/tactic_card_widget.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We don't need active session data here, just all cards
    final categories = ['System', 'Recipe', 'Concept', 'Explore', 'Character', 'Function', 'Structure', 'Style', 'Organise'];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final cardsInCategory = allCards.where((c) => c.category == category).toList();

        if (cardsInCategory.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                category,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 2100 / 1725,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: cardsInCategory.length,
              itemBuilder: (context, index) {
                return TacticCardWidget(
                  card: cardsInCategory[index],
                  contextCards: cardsInCategory,
                  index: index,
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
