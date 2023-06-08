import 'package:inventory_system/imports.dart';

class NotificationProvider {
  DataBaseService dbService = DataBaseService();
  NotificationModel notification = NotificationModel(
    '',
    id: 0,
    title: '',
    body: '',
    image: '',
  );

  NotificationProvider();

  Future<void> saveNotification(
      String title, String subTitle, String imageUrl) async {
    var connection = await dbService.getDatabaseConnection(notification);
    var highestId = await dbService.getHighestId(connection, notification);

    await dbService.insertRecord(
        connection,
        NotificationModel(
          const DateProvider().getDateWithTime(),
          id: highestId + 1,
          title: title,
          body: subTitle,
          image: imageUrl,
        ));
  }

  NotificationModel getInstance() {
    return notification;
  }
}
