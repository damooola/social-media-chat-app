import 'package:flutter/material.dart';

class MyUserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const MyUserTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              // icon
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.tertiary),
                child: Icon(
                  Icons.person_2_rounded,
                  size: 30,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(width: 20),

              // user name
              Text(
                text,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
              )
            ],
          ),
        ));
  }
}
