import 'package:inventory_system/imports.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key, required this.mainWidget});
  final String mainWidget;

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(bottom: 85),
        child: Drawer(
          width: MediaQuery.of(context).size.width * 0.75,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(35),
              bottomRight: Radius.circular(35),
            ),
          ),
          child: Column(
            children: [
              getDrawerHeader(),
              getDrawerList(widget.mainWidget, context, this),
              const Divider(
                color: Colors.grey,
              ),
              getAboutList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuItem(
      String title, IconData icon, bool selected, VoidCallback? onClicked) {
    print('Menu Item');
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return Material(
      color: selected ? Colors.grey.shade400 : Colors.transparent,
      child: InkWell(
        onTap: onClicked,
        hoverColor: hoverColor,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10,
            top: 20,
            bottom: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget getDrawerList(var mainWidget, context, homePageState) {
  print('getDrawerList');
  return Container(
    padding: const EdgeInsets.symmetric(
      vertical: 10,
    ),
    child: Column(
      children: [
        homePageState.menuItem(
            'product',
            Icons.event,
            mainWidget == 'product' ? true : false,
            () => selectedItem(context, 'product', homePageState)),
        homePageState.menuItem(
            'warehouse',
            Icons.warehouse,
            mainWidget == 'warehouse' ? true : false,
            () => selectedItem(context, 'warehouse', homePageState)),
        homePageState.menuItem(
            'order',
            Icons.description,
            mainWidget == 'order' ? true : false,
            () => selectedItem(context, 'order', homePageState)),
        homePageState.menuItem(
            'delivery',
            Icons.trolley,
            mainWidget == 'delivery' ? true : false,
            () => selectedItem(context, 'delivery', homePageState)),
      ],
    ),
  );
}

void selectedItem(BuildContext context, String title, homePageState) {
  print(title + " TITLE");
  Navigator.of(context).pop();
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => getContainerByName(title)));
}

StatelessWidget getContainerByName(String pageName) {
  print(pageName);
  var pages = {
    'product': const ProductPage(),
    'dashboard': const DashboardPage(),
    'warehouse': const WarehousePage(),
    'order': const OrderPage(),
    'delivery': const DeliveryPage(),
  };

  return pages[pageName] ?? const DashboardPage();
}

DrawerHeader getDrawerHeader() {
  return DrawerHeader(
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill, image: AssetImage(drawerHeaderImage))),
      child: Stack(children: const <Widget>[
        Positioned(
          bottom: 12.0,
          left: 12.0,
          child: Text("Warehouse and\n Logistics Order\n Management System",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold)),
        ),
      ]));
}

AboutListTile getAboutList() {
  return AboutListTile(
    applicationIcon: const Icon(
      Icons.local_play,
    ),
    applicationName: 'Warehouse and Logistics Order Management System',
    applicationVersion: '1.0.0',
    applicationLegalese: '© 2023',
    aboutBoxChildren: const [],
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.info,
            size: 24,
            color: Colors.grey.shade700,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            'About app',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}
