import 'package:inventory_system/imports.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        drawer: const NavigationWidget(mainWidget: ''),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: const CustomTabBar(selectedIndex: 1),
        ),
        body: const NotificationsPageWidget(),
      ),
    );
  }
}

class NotificationsPageWidget extends StatefulWidget {
  const NotificationsPageWidget({super.key});

  @override
  NotificationsPageWidgetState createState() => NotificationsPageWidgetState();
}

class NotificationsPageWidgetState extends State<NotificationsPageWidget> {
  var notifications = [];
  bool isLoading = true;
  NotificationModel notification =
      NotificationModel('', id: 0, title: '', body: '', image: '');
  var dbService = DataBaseService();
  var connection;

  Future<void> refreshNotifications() async {
    notifications = await dbService.getRecords(connection, notification);
    Comparator<NotificationModel> dateComparatorDescending =
        (a, b) => b.createdAt.compareTo(a.createdAt);
    notifications.cast<NotificationModel>().sort(dateComparatorDescending);
    print(notifications);
    isLoading = false;
  }

  Future<String> getDbConnection() async {
    connection ??= await dbService.getDatabaseConnection(notification);
    await refreshNotifications();

    return '';
  }

  Widget bodyBuilder(BuildContext context) {
    return isLoading
        ? Center(
            child:
                CircularProgressIndicatorWithText('Loading Notifications Data'),
          )
        : notifications.isNotEmpty
            ? SingleChildScrollView(
                child: GridView.builder(
                    itemCount: notifications.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 16 / 4,
                      crossAxisCount: 1,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffF7F7F7),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    height: 55,
                                    width: 55,
                                    child: Image(
                                        image: AssetImage(
                                            notifications[index].image)),
                                  )
                                ],
                              ),
                              const SizedBox(width: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    notifications[index].title,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  SizedBox(
                                    width: 280,
                                    child: Wrap(
                                      children: [
                                        Text(
                                          notifications[index].body,
                                          maxLines: 3,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    notifications[index].createdAt,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              )
            : Center(
                child: Text(
                'There are no notifications at the moment!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: getDbConnection(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return bodyBuilder(context);
          } else {
            return Center(
              child:
                  CircularProgressIndicatorWithText('Connecting To Database'),
            );
          }
        });
  }
}
