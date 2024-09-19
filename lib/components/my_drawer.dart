import 'package:flutter/material.dart';
import 'package:sm_chatapp/services/auth/auth_service.dart';
import 'package:sm_chatapp/components/my_drawer_tile.dart';
import 'package:sm_chatapp/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  final String currentUserEmail;
  const MyDrawer({super.key, required this.currentUserEmail});

  //Logout method
  void logOut() {
    final AuthService authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  //logo
                  DrawerHeader(
                    margin: const EdgeInsets.only(bottom: 25),
                    child: Transform.rotate(
                      angle: 85,
                      child: Icon(
                        Icons.message,
                        size: 70,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                  // a tile in the drawer to identify which user is currently logged in
                  MyDrawerTile(
                      text: currentUserEmail,
                      iconData: Icons.person_2_rounded,
                      onTap: () {}),

                  //home list tile
                  MyDrawerTile(
                      text: "Home",
                      iconData: Icons.home_filled,
                      onTap: () => Navigator.pop(context)),

                  //settings tile
                  MyDrawerTile(
                      text: "Settings",
                      iconData: Icons.settings,
                      onTap: () {
                        //pop the drawer
                        Navigator.pop(context);
                        // then go to settings page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ));
                      })
                ],
              ),
              // logout tile
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 30),
                child: MyDrawerTile(
                    text: "Log out",
                    iconData: Icons.logout_rounded,
                    onTap: logOut),
              )
            ]));
  }
}
