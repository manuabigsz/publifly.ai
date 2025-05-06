import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publifly_ai/src/shared/widgets/app_name.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../metrics_page/metrics_page.dart';
import '../../user_config_page/user_config_page.dart';
import '../home_page/home_page.dart';

class HomePageGeral extends StatefulWidget {
  const HomePageGeral({super.key});

  @override
  State<HomePageGeral> createState() => _HomePageGeralState();
}

class _HomePageGeralState extends State<HomePageGeral> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CurrentUserProvider>(context, listen: false)
          .buscaUsuarioAtual();
    });
    _pages = [
      const HomePage(),
      const MetricsPage(),
      const Center(),
      const UserSettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<CurrentUserProvider>(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.cinzaClaro,
      body: Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 50,
                      ),
                      const SizedBox(width: 18),
                      const AppNameWidget(),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _selectedIndex = 3;
                        },
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundImage: userProvider.userLogo != null
                              ? NetworkImage(userProvider.userLogo!)
                              : null,
                          backgroundColor: AppColors.logoColor,
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: userProvider.userLogo != null
                                ? NetworkImage(userProvider.userLogo!)
                                : const AssetImage('assets/images/logo.png')
                                    as ImageProvider,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              centerTitle: true,
              toolbarHeight: 80,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
          child: BottomAppBar(
            color: AppColors.logoColor,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            clipBehavior: Clip.antiAlias,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildNavBarItem(
                  icon: Icons.home,
                  iconSelected: Icons.home_filled,
                  title: "Home",
                  index: 0,
                ),
                _buildNavBarItem(
                  icon: Icons.dashboard_outlined,
                  iconSelected: Icons.dashboard,
                  title: "Ranking",
                  index: 1,
                ),
                _buildNavBarItem(
                  icon: Icons.notifications_none,
                  iconSelected: Icons.notifications,
                  title: "Notificações",
                  index: 2,
                ),
                _buildNavBarItem(
                  icon: Icons.person_outline,
                  iconSelected: Icons.person,
                  title: "Perfil",
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(
      {required IconData icon,
      required IconData iconSelected,
      required String title,
      required int index}) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? iconSelected : icon,
            color: isSelected ? AppColors.greenColor : Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }
}
