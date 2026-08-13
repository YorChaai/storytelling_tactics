import 'package:flutter/material.dart';
import '../data/cards_data.dart';
import 'card_detail_dialog.dart';

class TacticCardWidget extends StatelessWidget {
  final TacticCard card;
  final bool isInteractive;
  final List<TacticCard>? contextCards;
  final int? index;

  const TacticCardWidget({
    super.key, 
    required this.card,
    this.isInteractive = true,
    this.contextCards,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isInteractive ? () {
        showDialog(
          context: context,
          builder: (context) => CardDetailDialog(
            cards: contextCards ?? [card],
            initialIndex: index ?? 0,
          ),
        );
      } : null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51), // approx 0.2 * 255
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 2100 / 1725,
          child: Image.asset(
            card.imagePath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[800],
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Image not found:\n${card.imagePath}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
