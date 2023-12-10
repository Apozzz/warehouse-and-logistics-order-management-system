import 'package:flutter/material.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/features/notification/DAOs/notification_dao.dart';
import 'package:inventory_system/features/notification/models/notification_model.dart';
import 'package:inventory_system/shared/hoc/with_company_id.dart';
import 'package:inventory_system/shared/ui/widgets/base_scaffold.dart';
import 'package:provider/provider.dart';

class UserNotificationsPage extends StatelessWidget {
  const UserNotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: const Text('Your Notifications'),
      ),
      body: _buildNotificationsList(context),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    final notificationDAO =
        Provider.of<NotificationDAO>(context, listen: false);
    final userId =
        Provider.of<AuthViewModel>(context, listen: false).currentUser!.uid;

    return FutureBuilder<List<NotificationModel>?>(
      future: withCompanyId(
          context,
          (companyId) =>
              notificationDAO.getUserCompanyNotifications(userId, companyId)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildNoNotificationsWidget();
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) =>
                _buildNotificationTile(snapshot.data![index]),
          );
        }
      },
    );
  }

  Widget _buildNoNotificationsWidget() {
    return const Center(
      child: Text(
        'No notifications found.',
        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildNotificationTile(NotificationModel notification) {
    return ListTile(
      title: Text(notification.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(notification.body),
          Text('Scheduled: ${notification.scheduledTime}'),
        ],
      ),
      isThreeLine: true,
    );
  }
}
