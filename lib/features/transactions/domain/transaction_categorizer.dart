class CategorizedResult {
  final String cleanedMerchantName;
  final String categoryName;
  final String categoryColorHex;
  final String categoryIconName;
  final double confidenceScore;

  CategorizedResult({
    required this.cleanedMerchantName,
    required this.categoryName,
    required this.categoryColorHex,
    required this.categoryIconName,
    required this.confidenceScore,
  });
}

class TransactionCategorizer {
  /// Maps merchant keywords to clean names, categories, icons, and colors.
  static final List<Map<String, dynamic>> _merchantRules = [
    // --- FOOD & DINING ---
    {
      'keywords': ['starbucks', 'stb', 'coffee'],
      'cleanName': 'Starbucks',
      'category': 'Food & Dining',
      'icon': 'local_cafe',
      'color': '#FF10B981', // Emerald
      'confidence': 1.0
    },
    {
      'keywords': ['mcdonalds', 'mcdonald', 'mcd'],
      'cleanName': 'McDonald\'s',
      'category': 'Food & Dining',
      'icon': 'lunch_dining',
      'color': '#FF10B981',
      'confidence': 1.0
    },
    {
      'keywords': ['ubereats', 'uber eats', 'delivery'],
      'cleanName': 'Uber Eats',
      'category': 'Food & Dining',
      'icon': 'delivery_dining',
      'color': '#FF10B981',
      'confidence': 1.0
    },
    {
      'keywords': ['walmart', 'supermarket', 'groceries', 'grocery', 'costco', 'kroger', 'aldi'],
      'cleanName': 'Groceries',
      'category': 'Groceries',
      'icon': 'local_grocery_store',
      'color': '#FF059669', // Dark Emerald
      'confidence': 0.9
    },

    // --- TRANSPORT ---
    {
      'keywords': ['uber ride', 'uber.com', 'lyft', 'taxi', 'cab'],
      'cleanName': 'Uber/Lyft',
      'category': 'Transport',
      'icon': 'local_taxi',
      'color': '#FF3B82F6', // Blue
      'confidence': 0.95
    },
    {
      'keywords': ['shell', 'chevron', 'exxon', 'mobil', 'gas station', 'fuel'],
      'cleanName': 'Gas Station',
      'category': 'Transport',
      'icon': 'local_gas_station',
      'color': '#FF3B82F6',
      'confidence': 0.9
    },

    // --- ENTERTAINMENT ---
    {
      'keywords': ['netflix', 'nflx'],
      'cleanName': 'Netflix',
      'category': 'Entertainment',
      'icon': 'movie',
      'color': '#FFE11D48', // Ruby Red
      'confidence': 1.0
    },
    {
      'keywords': ['spotify'],
      'cleanName': 'Spotify',
      'category': 'Entertainment',
      'icon': 'music_note',
      'color': '#FFE11D48',
      'confidence': 1.0
    },
    {
      'keywords': ['playstation', 'psn', 'xbox', 'steam', 'epic games', 'nintendo'],
      'cleanName': 'Gaming',
      'category': 'Entertainment',
      'icon': 'sports_esports',
      'color': '#FFE11D48',
      'confidence': 0.95
    },

    // --- SHOPPING ---
    {
      'keywords': ['amazon', 'amzn'],
      'cleanName': 'Amazon',
      'category': 'Shopping',
      'icon': 'shopping_bag',
      'color': '#FFF59E0B', // Gold
      'confidence': 1.0
    },
    {
      'keywords': ['ebay', 'aliexpress', 'temu'],
      'cleanName': 'Online Shopping',
      'category': 'Shopping',
      'icon': 'shopping_cart',
      'color': '#FFF59E0B',
      'confidence': 0.95
    },
    {
      'keywords': ['zara', 'h&m', 'nike', 'adidas', 'uniqlo'],
      'cleanName': 'Clothing Store',
      'category': 'Shopping',
      'icon': 'checkroom',
      'color': '#FFF59E0B',
      'confidence': 0.9
    },

    // --- UTILITIES & BILLS ---
    {
      'keywords': ['t-mobile', 'tmobile', 'verizon', 'att', 'orange mobile'],
      'cleanName': 'Mobile Bill',
      'category': 'Utilities',
      'icon': 'phone_android',
      'color': '#FF8B5CF6', // Purple
      'confidence': 0.95
    },
    {
      'keywords': ['electric', 'power', 'water bill', 'utilities', 'comcast', 'internet'],
      'cleanName': 'Utilities',
      'category': 'Utilities',
      'icon': 'electrical_services',
      'color': '#FF8B5CF6',
      'confidence': 0.9
    },

    // --- INCOME ---
    {
      'keywords': ['payroll', 'salary', 'direct dep', 'employer', 'paycheck'],
      'cleanName': 'Salary Paycheck',
      'category': 'Income',
      'icon': 'payments',
      'color': '#FF10B981', // Green
      'confidence': 0.95
    }
  ];

  /// Categorizes a raw transaction statement description.
  /// Cleans the merchant name, assigns a category, icon, color, and confidence score.
  static CategorizedResult categorize(String rawDescription, double amount) {
    final normalized = rawDescription.toLowerCase().trim();

    // 1. Check against our defined merchant rules
    for (var rule in _merchantRules) {
      final List<String> keywords = rule['keywords'];
      for (var keyword in keywords) {
        if (normalized.contains(keyword)) {
          return CategorizedResult(
            cleanedMerchantName: rule['cleanName'],
            categoryName: rule['category'],
            categoryColorHex: rule['color'],
            categoryIconName: rule['icon'],
            confidenceScore: rule['confidence'],
          );
        }
      }
    }

    // 2. Fallback heuristic parsing (Regex name cleaning)
    // Remove terminal numbers, cities, states, card transaction IDs
    String cleanedName = rawDescription
        .replaceAll(RegExp(r'\*'), ' ')                     // Replace asterisks with spaces
        .replaceAll(RegExp(r'\d+'), '')                      // Remove digits
        .replaceAll(RegExp(r'#\w+'), '')                     // Remove hash codes
        .replaceAll(RegExp(r'\b(usa|uk|inc|co|ltd|llc|store|shop)\b', caseSensitive: false), '') // Remove business suffixes
        .trim();

    // Remove double spaces
    cleanedName = cleanedName.replaceAll(RegExp(r'\s+'), ' ');

    // Normalize spacing and casing (Title Case)
    if (cleanedName.isEmpty) {
      cleanedName = amount < 0 ? 'Outgoing Expense' : 'Incoming Funds';
    } else {
      cleanedName = cleanedName.split(' ')
          .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '')
          .join(' ')
          .trim();
    }

    // Determine category based on transaction flow
    if (amount >= 0) {
      return CategorizedResult(
        cleanedMerchantName: cleanedName,
        categoryName: 'Income',
        categoryColorHex: '#FF10B981', // Emerald green
        categoryIconName: 'trending_up',
        confidenceScore: 0.5,
      );
    } else {
      return CategorizedResult(
        cleanedMerchantName: cleanedName,
        categoryName: 'Shopping', // Default fallback category for expenses
        categoryColorHex: '#FFF59E0B', // Gold
        categoryIconName: 'shopping_bag',
        confidenceScore: 0.5,
      );
    }
  }
}
