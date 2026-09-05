import 'package:flutter/material.dart';
import '../components/tactic_card_widget.dart';
import '../data/cards_data.dart';

class AboutSystemScreen extends StatelessWidget {
  const AboutSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: systemCards.length,
      itemBuilder: (context, index) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: TacticCardWidget(
                card: systemCards[index],
                contextCards: systemCards,
                index: index,
              ),
            ),
          ),
        );
      },
    );
  }
}
