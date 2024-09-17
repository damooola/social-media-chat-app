import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm_chatapp/themes/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 5,
      ),
      body: GestureDetector(
        onTap: () =>
            Provider.of<ThemeProvider>(context, listen: false).changeTheme(),
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
              // darkmode text
              Text(
                "Dark Mode",
                style: TextStyle(
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
    );
  }
}
