import 'package:chatapp/pages/camera_page.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/widgets/bottom_bar_icon.dart';
import 'package:chatapp/widgets/home_view.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController pageController = PageController();
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeView(),
    HomeView(),
    HomeView(),
    HomeView(),
  ];

  void onTabTap(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: pages.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => pages[index],
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      bottomSheet: Container(
        color: Colors.white,
        height: 70,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BottomBarIcon(
                  icon: Icons.home,
                  isActive: selectedIndex == 0,
                  onTap: () => onTabTap(0),
                ),
                BottomBarIcon(
                  icon: Icons.search,
                  isActive: selectedIndex == 1,
                  onTap: () => onTabTap(1),
                ),
                BottomBarIcon(
                  icon: Icons.notifications,
                  isActive: selectedIndex == 2,
                  onTap: () => onTabTap(2),
                ),
                BottomBarIcon(
                  icon: Icons.account_box,
                  isActive: selectedIndex == 3,
                  onTap: () => onTabTap(3),
                ),
              ],
            ),
            // Add button
            Positioned(
              top: -20,
              child: GestureDetector(
                onTap: () {
                  // TODO: Define action for center floating button if needed
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 5),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final CameraDevice preferredCameraDevice =
                          CameraDevice.rear;
                      final ImageUtilityService imagePicker =
                          const ImageUtilityServiceImpl();
                      final file = await imagePicker.pickImageFromCamera(
                        cropImage: true,
                        preferredCameraDevice: preferredCameraDevice,
                      );
                    },
                    child: const Icon(Icons.camera, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
