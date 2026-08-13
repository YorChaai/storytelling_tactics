import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_session_provider.dart';
import '../data/cards_data.dart';
import '../components/tactic_card_widget.dart';

class ThreeStoriesScreen extends StatefulWidget {
  const ThreeStoriesScreen({super.key});

  @override
  State<ThreeStoriesScreen> createState() => _ThreeStoriesScreenState();
}

class _ThreeStoriesScreenState extends State<ThreeStoriesScreen> {
  List<List<TacticCard>> _stories = [];

  void _generateStories(GameSessionProvider session) {
    // Return previously drawn cards to the deck so we don't deplete it
    if (_stories.isNotEmpty) {
      for (var story in _stories) {
        session.returnCards(story);
      }
    }

    // Generate 3 sets of 3 cards
    final story1 = session.drawSpecificNumber(3);
    final story2 = session.drawSpecificNumber(3);
    final story3 = session.drawSpecificNumber(3);
    
    setState(() {
      _stories = [story1, story2, story3];
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<GameSessionProvider>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Bandingkan 3 kombinasi cerita dan pilih yang paling kuat.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: session.availableCards.length >= 9 
                      ? () => _generateStories(session) 
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('GENERATE 3 STORIES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () {
                  session.resetSession();
                  setState(() {
                    _stories = [];
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: const Text('RESET', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (session.availableCards.length < 9)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Tidak cukup kartu (butuh minimal 9). Silakan reset sesi.', 
                textAlign: TextAlign.center, 
                style: TextStyle(color: Colors.redAccent)
              ),
            ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: _stories.length,
              itemBuilder: (context, index) {
                final story = _stories[index];
                if (story.isEmpty) return const SizedBox.shrink();

                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.only(bottom: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Story ${index + 1}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: story.length,
                            separatorBuilder: (context, idx) => const SizedBox(width: 16),
                            itemBuilder: (context, idx) {
                              return AspectRatio(
                                aspectRatio: 2100 / 1725,
                                child: TacticCardWidget(
                                  card: story[idx],
                                  contextCards: story,
                                  index: idx,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
