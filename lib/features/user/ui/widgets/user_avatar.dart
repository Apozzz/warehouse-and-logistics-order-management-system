import 'package:flutter/material.dart';
import 'package:inventory_system/constants/route_paths.dart';
import 'package:inventory_system/features/user/models/user_model.dart';
import 'package:inventory_system/shared/extensions/navigator_extension.dart';

class UserAvatar extends StatelessWidget {
  final String userName;
  final User user;

  const UserAvatar({Key? key, required this.userName, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20), // Adjust the padding as needed
      child: InkWell(
        onTap: () {
          // Navigate to the UserDetailsFormPage with the user object
          Navigator.of(context).pushReplacementNamedNoTransition(
            RoutePaths.userDetails,
            arguments: user,
          );
        },
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // This keeps the row width to a minimum
          children: [
            CircleAvatar(
              // Display user's initial as avatar
              child: Text(userName.substring(0, 1)),
            ),
            const SizedBox(width: 8),
            Text(userName),
          ],
        ),
      ),
    );
  }
}
