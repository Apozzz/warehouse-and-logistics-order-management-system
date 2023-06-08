import 'package:inventory_system/imports.dart';

class CountGraphs extends StatelessWidget {
  const CountGraphs({super.key});

  List<dynamic> getList() {
    return [
      CountGraphCardInfo(ProductProvider(),
          text: 'Overall amount of Products', image: productImage),
      CountGraphCardInfo(WarehouseProvider(),
          text: 'Overall amount of Warehouses', image: warehouseImage),
      CountGraphCardInfo(OrderProvider(),
          text: 'Overall amount of Orders', image: orderImage),
      CountGraphCardInfo(DeliveryProvider(),
          text: 'Overall amount of Deliveries', image: deliveryImage),
    ];
  }

  Future<String> getCount(list, index) async {
    var count = await list[index].provider.getCount();

    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    var list = getList();
    var textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) => SizedBox(
          width: 250,
          height: 300,
          child: Padding(
            padding: const EdgeInsets.only(right: 10, top: 5, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF7F6F1),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(list[index].image),
                    height: 100,
                    width: 100,
                  ),
                  Flexible(
                    child: FutureBuilder<String>(
                      future: getCount(list, index),
                      builder: (context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data ?? '0',
                            style: textTheme.headline4,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicatorWithText(
                                'Getting Data'),
                          );
                        }
                      },
                    ),
                  ),
                  Flexible(
                    child: Text(
                      list[index].text,
                      style: textTheme.bodyText1,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CountGraphCardInfo {
  var provider;
  final String text;
  final String image;

  CountGraphCardInfo(this.provider, {required this.text, required this.image});
}
