import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_session_provider.dart';
import '../components/tactic_card_widget.dart';

class RandomDrawScreen extends StatefulWidget {
  const RandomDrawScreen({super.key});

  @override
  State<RandomDrawScreen> createState() => _RandomDrawScreenState();
}

class _RandomDrawScreenState extends State<RandomDrawScreen> {
  int _drawCount = 1;

  @override
  Widget build(BuildContext context) {
    final session = context.watch<GameSessionProvider>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withAlpha(25)),
            ),
            child: Row(
              children: [
                const Text('Draw:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _drawCount,
                  dropdownColor: const Color(0xFF1E293B),
                  items: [1, 2, 3, 4, 5].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _drawCount = value);
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: session.availableCards.isEmpty
                      ? null
                      : () => session.drawRandom(_drawCount),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                  child: const Text('DRAW', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: session.resetSession,
                  child: const Text('RESET'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Remaining: ${session.availableCards.length} | Drawn: ${session.drawnCards.length}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (session.latestDrawn.isNotEmpty) ...[
                    const Text(
                      'Latest Draw',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        childAspectRatio: 2100 / 1725,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: session.latestDrawn.length,
                      itemBuilder: (context, index) {
                        return TacticCardWidget(
                          card: session.latestDrawn[index],
                          contextCards: session.latestDrawn,
                          index: index,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 16),
                  ],
                  if (session.drawnCards.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('Belum ada kartu yang ditarik.'),
                      ),
                    )
                  else ...[
                    const Text(
                      'History (Semua Kartu Terpakai)',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2100 / 1725,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: session.drawnCards.length,
                      itemBuilder: (context, index) {
                        final reversedHistory = session.drawnCards.reversed.toList();
                        return TacticCardWidget(
                          card: reversedHistory[index],
                          contextCards: reversedHistory,
                          index: index,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
