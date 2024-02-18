import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
// import 'package:maanstore/screens/Auth_Screen/auth_screen_1.dart';
import 'package:maanstore/screens/auth_screen/sign_up.dart';
import 'package:maanstore/screens/edited_profile_screen.dart';
import 'package:maanstore/screens/order_screen/my_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../const/constants.dart';
import '../../models/add_to_cart_model.dart';
import '../cart_screen/cart_screen.dart';
import '../search_product_screen.dart';
import 'home_screen.dart';
import 'package:maanstore/generated/l10n.dart' as lang;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int customerId = 0;
  int cartItems = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> checkId() async {
    final prefs = await SharedPreferences.getInstance();
    customerId = prefs.getInt('customerId')!;
  }

  @override
  void initState() {
    checkId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Consumer(
        builder: (_, ref, child) {
          final cart = ref.watch(cartNotifier);
          cartItems = cart.cartItems.length;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            resizeToAvoidBottomInset: false,
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                const HomeScreen(),
                const SearchProductScreen(),
                const CartScreen(),
                customerId != 0 ? const MyOrderScreen() : const SignUp(),
                customerId != 0 ? const ProfileScreen() : const SignUp(),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Color.fromARGB(255, 33, 27, 27),
              items:  <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: const Icon(IconlyLight.home),
                    label:lang.S.of(context).home
                ),
                BottomNavigationBarItem(
                  icon: const Icon(IconlyLight.search),
                  label: lang.S.of(context).search,
                ),
                BottomNavigationBarItem(
                  icon: Badge(
                      label: Text('${cart.cartOtherInfoList.length}'),
                      child: const Icon(IconlyLight.bag)),
                  label: lang.S.of(context).cart,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(IconlyLight.document),
                  label: lang.S.of(context).orders,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(IconlyLight.profile),
                  label: lang.S.of(context).profile,
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: kPrimaryColor,
              unselectedItemColor: textColors,
              unselectedLabelStyle: const TextStyle(color: textColors),
              onTap: _onItemTapped,
            ),
          );
        },
      ));
  }
}
