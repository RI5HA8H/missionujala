


import 'package:flutter/material.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';

import '../../generated/assets.dart';
import '../../userProfile.dart';

class appBar extends StatelessWidget implements PreferredSizeWidget {
  const appBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: 50,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Image.asset(Assets.iconsMenuIcon,color: appcolors.primaryColor,width: 50,height: 50,),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      title: Image.asset(Assets.imagesMuAppbarLogo,height: 50,),
      actions: [
        IconButton(
          icon: Image.asset(Assets.imagesDepartmentLogo,width: 50,height: 50,),
          onPressed: () {
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
          },
        ),
        IconButton(
          icon: Image.asset(Assets.imagesProfileLogo,width: 50,height: 50,),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
          },
        ),
      ],

    );
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
