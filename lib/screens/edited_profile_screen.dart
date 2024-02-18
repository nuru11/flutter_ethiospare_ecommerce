import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:maanstore/Providers/all_repo_providers.dart';
import 'package:maanstore/api_service/api_service.dart';
import 'package:maanstore/const/constants.dart';
import 'package:maanstore/screens/Theme/theme.dart';
import 'package:maanstore/screens/auth_screen/change_pass_screen.dart';
import 'package:maanstore/screens/home_screens/home.dart';
import 'package:maanstore/screens/language_screen.dart';
import 'package:maanstore/screens/notification_screen/notificition_screen.dart';
import 'package:maanstore/screens/order_screen/my_order.dart';
import 'package:maanstore/screens/order_screen/payment_method_screen.dart';
import 'package:maanstore/screens/profile_screen/my_profile_screen.dart';
import 'package:maanstore/screens/splash_screen/splash_screen_one.dart';
import 'package:maanstore/widgets/profile_shimmer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maanstore/generated/l10n.dart' as lang; 
// import 'package:google_fonts/google_fonts.dart';



ThemeManager _themeManager = ThemeManager();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  APIService? apiService;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  void getCustomerData(String name, String url) async {
    SharedPreferences preferences = await _prefs;
    preferences.setString('name', name);
    preferences.setString('url', url);
  }

  @override
  initState() {
    apiService = APIService();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer(builder: (context, ref, __) {

      final customerDetails = ref.watch(getCustomerDetails);
    //  var langD;
      return Directionality(

        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Home()));
              },
              child:  Icon(
                Icons.arrow_back,
                color: isDark ? darkTitleColor : lightTitleColor,
              ),
            ),
            title: Text(
              lang.S.of(context).profileScreenName,
              style: kTextStyle.copyWith(color: isDark ? darkTitleColor : lightTitleColor, fontSize: 20.0),
            ),
           
          ),


          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: customerDetails.when(data: (snapShot) {
              String name = snapShot.username.toString();
              getCustomerData(name, snapShot.avatarUrl.toString());
              return Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 30, top: 30, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration:  BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(50)),
                                image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: NetworkImage(snapShot.avatarUrl.toString()),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyGoogleText(text: '${snapShot.username} ', fontSize: 24, fontColor: isDark ? darkTitleColor : lightTitleColor, fontWeight: FontWeight.normal),
                                  const SizedBox(height: 8),
                                  MyGoogleText(text: snapShot.email.toString(), fontSize: 14, fontColor: isDark ? darkGreyTextColor : lightGreyTextColor, fontWeight: FontWeight.normal),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        ///_____My_profile_____________________________
                        Container(
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: secondaryColor3))),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> MyProfileScreen(retrieveCustomer: snapShot,)));
                            },
                            shape: const Border(bottom: BorderSide(width: 1, color: textColors)),
                            leading: const Icon(IconlyLight.profile),
                            title: MyGoogleText(text: lang.S.of(context).myProfile, fontSize: 16, fontColor: isDark ? darkTitleColor : lightTitleColor, fontWeight: FontWeight.normal),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ),
                        ),

                        ///_____Change_password_____________________________
                        Visibility(
                          visible: false,
                          child: Container(
                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: secondaryColor3))),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ChangePassScreen()));
                              },
                              shape: const Border(bottom: BorderSide(width: 1, color: textColors)),
                              leading: const Icon(IconlyLight.password),
                              title:  MyGoogleText(text: 'Change Password', fontSize: 16, fontColor: isDark ? darkTitleColor : lightTitleColor, fontWeight: FontWeight.normal),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                            ),
                          ),
                        ),

                        ///_____My_Order____________________________
                        Container(
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: secondaryColor3))),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyOrderScreen()));
                            },
                            shape: const Border(bottom: BorderSide(width: 1, color: textColors)),
                            leading: const Icon(IconlyLight.document),
                            title: MyGoogleText(text: lang.S.of(context).myOrderScreenName, fontSize: 16, fontColor: isDark ? darkTitleColor : lightTitleColor, fontWeight: FontWeight.normal),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ),
                        ),

                        ///__________payment_method______________________-
                        Visibility(
                          visible: false,
                          child: Container(
                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: secondaryColor3))),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const PaymentMethodScreen()));
                              },
                              shape: const Border(bottom: BorderSide(width: 1, color: textColors)),
                              leading: const Icon(IconlyLight.wallet),
                              title:  MyGoogleText(text: 'Payment Method', fontSize: 16, fontColor: isDark ? darkTitleColor : lightTitleColor, fontWeight: FontWeight.normal),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                            ),
                          ),
                        ),

                        ///_________Notification___________________________
                        Visibility(
                          visible: false,
                          child: Container(
                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: secondaryColor3))),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const NotificationsScreen()));
                              },
                              shape: const Border(bottom: BorderSide(width: 1, color: textColors)),
                              leading: const Icon(IconlyLight.notification),
                              title:  MyGoogleText(text: 'Notification', fontSize: 16, fontColor:isDark ? darkTitleColor : lightTitleColor, fontWeight: FontWeight.normal),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                            ),
                          ),
                        ),

                        ///_____________Language________________________
                        Container(
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: secondaryColor3))),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const LanguageScreen()));
                            },
                            shape: const Border(bottom: BorderSide(width: 1, color: textColors)),
                            leading: const Icon(CommunityMaterialIcons.translate),
                            title: MyGoogleText(text: lang.S.of(context).language, fontSize: 16, fontColor: isDark ? darkTitleColor : lightTitleColor, fontWeight: FontWeight.normal),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ),
                        ),

                        ///___________________Help___________________________
                        Visibility(
                          visible: false,
                          child: Container(
                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: secondaryColor3))),
                            child:  ListTile(
                              onTap: null,
                              shape: const Border(bottom: BorderSide(width: 1, color: textColors)),
                              leading: const Icon(IconlyLight.danger),
                              title: MyGoogleText(text: 'Help & Info', fontSize: 16, fontColor: isDark ? darkTitleColor : lightTitleColor, fontWeight: FontWeight.normal),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        ///-------------theme---------------
                        // Container(
                        //   decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: secondaryColor3))),
                        //   child: ListTile(
                        //     leading: const Icon(CommunityMaterialIcons.brightness_6,),
                        //     contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        //     horizontalTitleGap: 10,
                        //     title:  const Text('Dark Theme'),
                        //     trailing: Switch(
                        //       value: _themeManager.themeMode == ThemeMode.dark,
                        //       onChanged: (newValue) async {
                        //         SharedPreferences prefs = await SharedPreferences.getInstance();
                        //         newValue ? await prefs.setString('theme', 'dark') : await prefs.setString('theme', 'light');
                        //         setState(() {
                        //           _themeManager.toggleTheme(newValue);
                        //         });
                        //       },
                        //     ),
                        //   ),
                        // ),
                        ///______________SignOut_________________________
                        Container(
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: secondaryColor3))),
                          child: ListTile(
                            onTap: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.remove('customerId');
                              if (!mounted) return;
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const SplashScreenOne()));
                            },
                            shape: const Border(bottom: BorderSide(width: 1, color: textColors)),
                            leading: const Icon(IconlyLight.logout),
                            title: MyGoogleText(text: lang.S.of(context).signOut, fontSize: 16, fontColor: isDark ? darkTitleColor : lightTitleColor, fontWeight: FontWeight.normal),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }, error: (e, stack) {
              return Text(e.toString());
            }, loading: () {
              return const ProfileShimmerWidget();
            }),
          ),
        ),
      );
    });
  }
}

