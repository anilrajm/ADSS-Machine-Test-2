import 'package:adss_machine_test_e_commerce/models/restaurant_data_model.dart';
import 'package:adss_machine_test_e_commerce/providers/dishes_provider.dart';
import 'package:adss_machine_test_e_commerce/widgets/build_dish_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/cart_provider.dart';

class ScreenUserHome extends StatefulWidget {
  const ScreenUserHome({Key? key}) : super(key: key);

  @override
  State<ScreenUserHome> createState() => _ScreenUserHomeState();
}

class _ScreenUserHomeState extends State<ScreenUserHome>
    with SingleTickerProviderStateMixin {
  String? _user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loadDishes = Provider.of<DishesProvider>(context, listen: false);
      await loadDishes.getDishes(context);
    });
    getUser();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _user = prefs.getString('user');
    });
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context, listen: false);
    var loadDishes = Provider.of<DishesProvider>(context);
    if (loadDishes.isLoading) {
      return Scaffold(
          body: Center(
        child: Lottie.asset('assets/lotties/loading-home.json',
            fit: BoxFit.contain),
      ));
    } else {
      return Consumer<DishesProvider>(
        builder: (BuildContext context, restaurant, child) {
          List<TableMenuList> filterMenu({required String menuId}) {
            List<TableMenuList> filteredMenu = restaurant
                .dishes![0].tableMenuList
                .where((menu) => menu.menuCategoryId == menuId)
                .toList();
            return filteredMenu;
          }

          return DefaultTabController(
            length: restaurant.dishes![0].tableMenuList.length,
            child: Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Scaffold(
                  appBar: AppBar(
                    actions: [
                      Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: Badge(
                            label: Text(cart.cartDishes.length.toString()),
                            child: IconButton(
                                icon: Icon(
                                  Icons.shopping_cart,
                                  size: 30.r,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/checkoutScreen');
                                }),
                          )),
                    ],
                    bottom: TabBar(
                      isScrollable: true,
                      tabs: List.generate(
                          restaurant.dishes![0].tableMenuList.length,
                          (index) => Tab(
                                text: restaurant.dishes![0].tableMenuList[index]
                                    .menuCategory,
                              )),
                    ),
                  ),
                  drawer: Drawer(
                    child: ListView(
                      children: [
                        UserAccountsDrawerHeader(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor,
                              Colors.green
                            ])),
                            currentAccountPicture: const CircleAvatar(
                                foregroundImage: NetworkImage(
                                    'https://cdn.pixabay.com/photo/2019/08/11/18/59/icon-4399701_640.png')
                                // AssetImage('assets/profile_vector.jpg')
                                ),
                            accountName: Text(_user ?? ''),
                            accountEmail: const Text('anil.test@gmail.com')),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 10.w),
                            child: ListTile(
                              leading: Icon(
                                Icons.logout_rounded,
                                size: 29.r,
                              ),
                              title: Text(
                                'Log Out',
                                style: TextStyle(fontSize: 18.sp),
                              ),
                              onTap: () async {
                                try {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.remove('user');
                                  Navigator.pushNamed(context, '/phoneAuth');

                                } catch (e) {
                                  print(e.toString());
                                }
                              },
                            )),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      BuildDishTiles(
                        menuCategory: filterMenu(menuId: '1'),
                      ),
                      BuildDishTiles(
                        menuCategory: filterMenu(menuId: '2'),
                      ),
                      BuildDishTiles(
                        menuCategory: filterMenu(menuId: '3'),
                      ),

                    ],
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }
}
