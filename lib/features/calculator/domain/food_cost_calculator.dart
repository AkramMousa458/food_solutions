enum FoodCostStatus { good, low, average, high }

class FoodCostResult {
  final double foodCostPercentage;
  final double costPerServing;
  final double profitPerServing;
  final double profitMargin;
  final double markup;
  final double totalRevenue;
  final double totalProfit;
  final FoodCostStatus status;
  final Map<int, double> suggestedPrices;

  const FoodCostResult({
    required this.foodCostPercentage,
    required this.costPerServing,
    required this.profitPerServing,
    required this.profitMargin,
    required this.markup,
    required this.totalRevenue,
    required this.totalProfit,
    required this.status,
    required this.suggestedPrices,
  });
}

class FoodCostCalculator {
  static const List<int> suggestedTargets = [25, 28, 30, 35];

  static FoodCostResult? calculate({
    required double ingredientCost,
    required double sellingPrice,
    required double servings,
  }) {
    if (servings <= 0 || sellingPrice <= 0 || ingredientCost < 0) return null;

    final costPerServing = ingredientCost / servings;
    final foodCostPercentage = (costPerServing / sellingPrice) * 100.0;
    final profitPerServing = sellingPrice - costPerServing;
    final profitMargin = (profitPerServing / sellingPrice) * 100.0;
    final markup = costPerServing > 0
        ? (profitPerServing / costPerServing) * 100.0
        : 0.0;
    final totalRevenue = sellingPrice * servings;
    final totalProfit = profitPerServing * servings;

    final suggestedPrices = <int, double>{
      for (final target in suggestedTargets)
        target: costPerServing / (target / 100.0),
    };

    return FoodCostResult(
      foodCostPercentage: foodCostPercentage,
      costPerServing: costPerServing,
      profitPerServing: profitPerServing,
      profitMargin: profitMargin,
      markup: markup,
      totalRevenue: totalRevenue,
      totalProfit: totalProfit,
      status: _resolveStatus(foodCostPercentage),
      suggestedPrices: suggestedPrices,
    );
  }

  static FoodCostStatus _resolveStatus(double percentage) {
    if (percentage >= 28 && percentage <= 30) return FoodCostStatus.good;
    if (percentage < 28) return FoodCostStatus.low;
    if (percentage <= 35) return FoodCostStatus.average;
    return FoodCostStatus.high;
  }
}
