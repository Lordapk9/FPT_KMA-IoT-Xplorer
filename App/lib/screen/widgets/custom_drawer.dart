import 'package:home_iot_device/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});
  
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Drawer(
        shape:const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            bottomRight:  Radius.circular(50),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: AppColor.fgColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight:  Radius.circular(50),
          ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon:const Icon(Icons.close, color: AppColor.white),
                      );
                    }
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: size.width*0.2,
                    height: size.width*0.2,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/800px-User_icon_2.svg.png"),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        width: 2,
                        color: AppColor.white,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hi You",
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          ),
                        ),
                        OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.white,
                      side: const BorderSide(
                          color: AppColor.white,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  )
                    ],

                    
                  ),
                  
                ],
              ),
              const Divider(
                    thickness: 0.5,
                    color: AppColor.white,
                    height: 40,
                  ),
                  drawerTile(Icons.people_alt_outlined,"Manage User", () {}),
                  drawerTile(Icons.tv_outlined,"Devices", () {}),
                  drawerTile(Icons.people_alt_outlined,"Manage User", () {}),
                  drawerTile(Icons.settings,"Settings", () {}),
                  const Spacer(),
                  drawerTile(Icons.logout,"Logout", () {}),
            ],
          ),

        ),
        
      ),
    );
  }

  ListTile drawerTile(IconData icon, String title,VoidCallback ontap) {
    return ListTile(
      onTap: ontap,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      leading: Icon(
        icon,
        color: AppColor.white,

      ),
      title: Text(
        title,
        style: TextStyle(
        color: AppColor.white
      ),
      ),
    );
  }
  
}