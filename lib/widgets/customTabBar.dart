import 'package:inventory_system/imports.dart';

class CustomTabBar extends StatefulWidget {
  final int selectedIndex;

  const CustomTabBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  List<IconData> icons = [
    Icons.home,
    Icons.notifications,
    Icons.lock,
    Icons.download,
  ];

  List<String> iconsTexts = [
    'Home',
    'Notifications',
    'Security',
    'Import/Export',
  ];

  List<Widget> pages = [
    const DashboardPage(),
    const NotificationsPage(),
    const SecurityPage(),
    const ImportExportPage(),
  ];

  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  List<GButton> getTabsList() {
    return List.generate(icons.length, (index) {
      return GButton(
        icon: icons[index],
        text: iconsTexts[index],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: GNav(
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 8,
          activeColor: Colors.black,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: Colors.grey[100]!,
          color: Colors.black,
          tabs: getTabsList(),
          tabActiveBorder: Border.all(),
          selectedIndex: selectedIndex,
          onTabChange: (index) {
            setState(() {
              if (index != selectedIndex) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => pages[index]));
              }
            });
          },
        ),
      ),
    );
  }
}
