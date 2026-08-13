import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/cards_data.dart';
import '../data/recipes_data.dart';
import '../providers/game_session_provider.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _goalController = TextEditingController();
  
  final Set<String> _selectedCardIds = {};

  @override
  void dispose() {
    _nameController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCardIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih setidaknya 1 kartu taktik!')),
        );
        return;
      }

      final customCards = allCards
          .where((c) => _selectedCardIds.contains(c.id))
          .toList();

      final newRecipe = Recipe(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        goal: _goalController.text.trim(),
        recommendedTacticIds: [],
        isCustom: true,
        customCards: customCards,
      );

      context.read<GameSessionProvider>().addCustomRecipe(newRecipe);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Exclude system and recipe cards from being selectable as ingredients
    final selectableCards = allCards.where((c) => !c.id.startsWith('card_0_')).toList();

    // Group cards by category
    final Map<String, List<TacticCard>> groupedCards = {};
    for (var card in selectableCards) {
      if (!groupedCards.containsKey(card.category)) {
        groupedCards[card.category] = [];
      }
      groupedCards[card.category]!.add(card);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Recipe Baru'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveRecipe,
            tooltip: 'Simpan',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Recipe',
                  hintText: 'Misal: Cerita untuk TikTok',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama recipe tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(
                  labelText: 'Tujuan (Goal)',
                  hintText: 'Misal: Menarik perhatian audiens dalam 3 detik',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Tujuan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Pilih Kartu Taktik (Ingredients):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: groupedCards.keys.length,
                  itemBuilder: (context, index) {
                    final category = groupedCards.keys.elementAt(index);
                    final cardsInCategory = groupedCards[category]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            category,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6366F1)),
                          ),
                        ),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 2100 / 1725,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: cardsInCategory.length,
                          itemBuilder: (context, cardIndex) {
                            final card = cardsInCategory[cardIndex];
                            final isSelected = _selectedCardIds.contains(card.id);

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    _selectedCardIds.remove(card.id);
                                  } else {
                                    _selectedCardIds.add(card.id);
                                  }
                                });
                              },
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
                                        width: 4,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(card.imagePath, fit: BoxFit.contain),
                                    ),
                                  ),
                                  if (isSelected)
                                    const Positioned(
                                      top: 8,
                                      right: 8,
                                      child: CircleAvatar(
                                        backgroundColor: Color(0xFF6366F1),
                                        radius: 16,
                                        child: Icon(Icons.check, color: Colors.white, size: 20),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
