import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
        child: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
          appbarButton(icon: Icons.home, onPressed: ()=>{Navigator.pushNamed(context, "/")}),
          appbarButton(icon: Icons.add_location_alt,
              onPressed: () => {Navigator.pushNamed(context, "/second")}),
          appbarButton(icon: Icons.access_alarm, onPressed: () => {}),
        ])),
        preferredSize: preferredSize);

  }
}


Widget appbarButton({icon, onPressed}) {
  return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        child: Icon(icon),
        onPressed: onPressed,
      ));
}
