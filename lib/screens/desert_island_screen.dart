import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_session_provider.dart';
import '../data/cards_data.dart';
import '../components/tactic_card_widget.dart';

class DesertIslandScreen extends StatelessWidget {
  const DesertIslandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = context.watch<GameSessionProvider>();
    final desertIslandCards = allCards.where((c) => c.isDesertIsland).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Bermain menggunakan 7 kartu inti. Cocok untuk pemula.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              session.drawRandom(1, subset: desertIslandCards);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF14B8A6),
              padding: const EdgeInsets.all(16),
            ),
            child: const Text('DRAW 1 DESERT ISLAND CARD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: session.resetSession,
            child: const Text('RESET SESSION'),
          ),
          const SizedBox(height: 24),
          const Text('Drawn Cards (Desert Island Mode)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 2100 / 1725,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: session.drawnCards.length,
              itemBuilder: (context, index) {
                return TacticCardWidget(
                  card: session.drawnCards[index],
                  contextCards: session.drawnCards,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
