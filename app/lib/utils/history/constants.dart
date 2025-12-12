import 'package:excerbuys/types/enums.dart';

class HistoryCategoryButton {
  final String icon;
  final RECENT_DATA_CATEGORY category;

  const HistoryCategoryButton({
    required this.icon,
    required this.category,
  });
}

const List<HistoryCategoryButton> HISTORY_CATEGORY_BUTTONS = [
  HistoryCategoryButton(
      icon: 'assets/svg/dumbell.svg',
      category: RECENT_DATA_CATEGORY.WORKOUTS),
  HistoryCategoryButton(
      icon: 'assets/svg/wallet.svg',
      category: RECENT_DATA_CATEGORY.TRANSACTIONS),
];
