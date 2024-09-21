import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_chatapp/components/my_app_bar.dart';
import 'package:sm_chatapp/themes/theme_provider.dart';

import 'blocked_users_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  // go to blocked user page
  void goToBlockedUsersPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlockedUsersPage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(text: "Settings"),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            // dark mode button
            GestureDetector(
              onTap: () => Provider.of<ThemeProvider>(context, listen: false)
                  .changeTheme(),
              child: Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // darkmode text
                    Text(
                      "Dark Mode",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),

                    // toggle switch
                    CupertinoSwitch(
                      trackColor: Theme.of(context).colorScheme.inversePrimary,
                      value: Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkMode,
                      onChanged: (value) =>
                          Provider.of<ThemeProvider>(context, listen: false)
                              .changeTheme(),
                    )
                  ],
                ),
              ),
            ),
            // blocked users button
            GestureDetector(
              onTap: () => goToBlockedUsersPage(context),
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Blocked Users",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),

                    // goto blocked users page button
                    IconButton(
                        onPressed: () => goToBlockedUsersPage(context),
                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
