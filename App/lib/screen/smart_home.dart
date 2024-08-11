  import 'package:flutter/cupertino.dart';
  import 'package:home_iot_device/constants/app_colors.dart';
  import 'package:home_iot_device/model/smart_home_model.dart';
  import 'package:home_iot_device/screen/room_card.dart';
  import 'package:home_iot_device/screen/widgets/custom_drawer.dart';
  import 'package:flutter/material.dart';

  class SmartHomeScreen extends StatefulWidget{
    const SmartHomeScreen({super.key});

    @override
    State<SmartHomeScreen> createState() => _SmartHomeScreenSate();
    
  }

  class _SmartHomeScreenSate extends State<SmartHomeScreen>{
    @override
    Widget build(BuildContext context) {
      final size = MediaQuery.of(context).size;
      ListData smartHomeModel = ListData();
      return Scaffold(
        drawer: const CustomDrawer(),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height*0.3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: const Icon(Icons.menu),
                            );
                        }
                      ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "27\u00b0",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        width: 90,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 5,
                              color: AppColor.black.withOpacity(.1),
                            )
                          ],
                          borderRadius:const BorderRadius.only(
                            topLeft: Radius.circular(35),
                            bottomLeft: Radius.circular(35),
                          ),
                        ),
                        child: Container(
                          width: 40,
                          height: 35,
                          decoration:const BoxDecoration(
                            color: AppColor.fgColor,
                            shape: BoxShape.circle,
                          ),
                          child:const Icon(Icons.add,size: 38,color: AppColor.white),
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         const Text("Total", 
                  //           style: TextStyle(
                  //             fontSize: 30, 
                              
                  //             fontWeight: FontWeight.w600,),
                  //             ),
                  //         Text("Consumption", 
                  //           style: TextStyle(
                  //             fontSize: 30, 
                  //             color: AppColor.fgColor.withOpacity(.5),
                  //             fontWeight: FontWeight.w500,),
                  //             ),
                  //       ],
                  //     ),
                      


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        const Text(
                          "All Room",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                                Icons.arrow_forward_ios,
                              ),
                            ),
                        ],
                      )
                    ],
                    
                  ),
                
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: smartHomeModel.smartHomeData.length + 2,
                  itemBuilder: (context,index) {
                  if(index == 0 || smartHomeModel.smartHomeData.length + 1 == index){
                    return Container(
                      width: 20,
                      height: size.height*0.5,
                      
                      color: Colors.transparent,
                  );
                }
                  final data = smartHomeModel.smartHomeData[index - 1];
                  return RoomCard(roomData: data);
                }),
              ),
            ],
          ),
        ),
      );
    }

    Container userPicture(String imageurl) {
      return Container(
                      width: 50,
                      height: 10,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AppColor.fgColor.withOpacity(.1),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(imageurl),
                          ),
                      ),
                      
                    );
    }
    
  }