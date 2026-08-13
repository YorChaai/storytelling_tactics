import 'cards_data.dart';

class Recipe {
  final String id;
  final String name;
  final String goal;
  final List<String> recommendedTacticIds;
  final bool isCustom;
  final List<TacticCard>? customCards;

  const Recipe({
    required this.id,
    required this.name,
    required this.goal,
    required this.recommendedTacticIds,
    this.isCustom = false,
    this.customCards,
  });
}

const List<Recipe> allRecipes = [
  Recipe(
    id: "recipe_1",
    name: "Stories that Sell",
    goal: "Menjual produk atau ide.",
    recommendedTacticIds: [],
  ),
  Recipe(
    id: "recipe_2",
    name: "Stories that Motivate",
    goal: "Memotivasi tim atau diri sendiri.",
    recommendedTacticIds: [],
  ),
  Recipe(
    id: "recipe_3",
    name: "Stories that Convince",
    goal: "Meyakinkan seseorang (investor, atasan).",
    recommendedTacticIds: [],
  ),
  Recipe(
    id: "recipe_4",
    name: "Stories that Connect",
    goal: "Membangun hubungan dengan audiens.",
    recommendedTacticIds: [],
  ),
  Recipe(
    id: "recipe_5",
    name: "Stories that Explain",
    goal: "Menjelaskan ide yang rumit.",
    recommendedTacticIds: [],
  ),
  Recipe(
    id: "recipe_6",
    name: "Stories that Lead",
    goal: "Menjadi pemimpin yang lebih baik.",
    recommendedTacticIds: [],
  ),
  Recipe(
    id: "recipe_7",
    name: "Stories that Impress",
    goal: "Meninggalkan kesan yang mendalam.",
    recommendedTacticIds: [],
  ),
];
