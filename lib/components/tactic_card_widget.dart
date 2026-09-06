import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/cards_data.dart';
import '../providers/settings_provider.dart';
import 'fullscreen_viewer.dart';

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
    final settings = context.watch<SettingsProvider>();
    final imagePath = card.getImagePath(settings.cardLanguage);

    return GestureDetector(
      onTap: isInteractive ? () {
        showDialog(
          context: context,
          builder: (context) => FullscreenViewer(
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
            imagePath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[800],
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Image not found:\n$imagePath',
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
