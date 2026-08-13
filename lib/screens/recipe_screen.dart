import 'package:flutter/material.dart';
import '../data/recipes_data.dart';
import '../data/cards_data.dart';
import '../components/tactic_card_widget.dart';
import '../providers/game_session_provider.dart';
import 'package:provider/provider.dart';
import 'create_recipe_screen.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  Recipe? _selectedRecipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _selectedRecipe == null ? _buildRecipeList(context) : _buildRecipeDetail(context),
      ),
      floatingActionButton: _selectedRecipe == null
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CreateRecipeScreen()),
                );
              },
              backgroundColor: const Color(0xFF6366F1),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Buat Recipe Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }

  Widget _buildRecipeList(BuildContext context) {
    final session = context.watch<GameSessionProvider>();
    final combinedRecipes = [...allRecipes, ...session.customRecipes];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Pilih Recipe yang sesuai dengan goal Anda.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            itemCount: combinedRecipes.length,
            itemBuilder: (context, index) {
              final recipe = combinedRecipes[index];
              return Card(
                color: const Color(0xFF1E293B),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Row(
                    children: [
                      Text(recipe.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6366F1))),
                      if (recipe.isCustom) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.pinkAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('CUSTOM', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Text(recipe.goal),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    setState(() {
                      _selectedRecipe = recipe;
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeDetail(BuildContext context) {
    final recipe = _selectedRecipe!;
    
    Widget content;
    
    if (recipe.isCustom && recipe.customCards != null) {
      // Display custom selected cards
      content = GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          childAspectRatio: 2100 / 1725,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: recipe.customCards!.length,
        itemBuilder: (context, index) {
          return TacticCardWidget(
            card: recipe.customCards![index],
            contextCards: recipe.customCards,
            index: index,
          );
        },
      );
    } else {
      // Original behavior for built-in recipes
      final recipeCard = allCards.firstWhere(
        (c) => c.name == recipe.name,
        orElse: () => allCards.first,
      );
      content = Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          child: TacticCardWidget(card: recipeCard),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _selectedRecipe = null;
            });
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(recipe.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            if (recipe.isCustom)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('CUSTOM', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(recipe.goal, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 24),
        Expanded(child: content),
        if (!recipe.isCustom)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Mekanisme subset taktik untuk resep ini dapat ditambahkan di pengembangan selanjutnya saat metadata terisi penuh.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          )
      ],
    );
  }
}
