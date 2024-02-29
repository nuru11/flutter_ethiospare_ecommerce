import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:maanstore/api_service/api_service.dart';
import 'package:maanstore/generated/l10n.dart' as lang; 
// import 'package:maanstore/main.dart';
import 'package:maanstore/screens/Theme/theme.dart';
import 'package:maanstore/screens/auth_screen/sign_up.dart';
// import 'package:maanstore/screens/auth_screen/sign_up.dart';
import 'package:maanstore/screens/cart_screen/cart_screen.dart';
import 'package:maanstore/screens/category_screen/category_screen.dart';
import 'package:maanstore/screens/category_screen/single_category_screen.dart';
import 'package:maanstore/screens/contact_us_screen.dart';
import 'package:maanstore/screens/edited_profile_screen.dart';
import 'package:maanstore/screens/language_screen.dart';
import 'package:maanstore/screens/order_screen/my_order.dart';
// import 'package:maanstore/screens/home_screens/home.dart';
import 'package:maanstore/screens/product_details_screen/product_detail_screen.dart';
import 'package:maanstore/screens/search_product_screen.dart';
import 'package:maanstore/screens/splash_screen/splash_screen_one.dart';
import 'package:maanstore/widgets/banner_shimmer_widget.dart';
import 'package:maanstore/widgets/product_shimmer_widget.dart';
// import 'package:maanstore/widgets/shape.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../Providers/all_repo_providers.dart';
import '../../const/constants.dart';
import '../../const/hardcoded_text.dart';
import '../../models/category_model.dart';
import '../../widgets/product_greed_view_widget.dart';

import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   late APIService apiService;
  String? name;
  String? url;

  int customerId = 0;

  Future<void> checkId() async {
    final prefs = await SharedPreferences.getInstance();
    int? storedCustomerId = prefs.getInt('customerId');

    if (storedCustomerId != null) {
      // User is logged in
      setState(() {
        customerId = storedCustomerId;
      });
    } else {
      // User is not logged in
      setState(() {
        customerId = 0;
      });
    }
  }

  // @override
  // void initState() {
  //   apiService = APIService();
  //  // Call checkId() to retrieve the customerId when the screen is initialized
  //   super.initState();
  // }

  

  // Future<void> initMessaging() async {
  //   await OneSignal.shared.setAppId(oneSignalAppId);
  //   OneSignal.shared.setInAppMessageClickedHandler((action) {
  //     if (action.clickName == 'successPage') {
  //       toast(lang.S.of(context).easyLoadingSuccess);
  //     }
  //   });
  // }

  @override
  void initState() {
    apiService = APIService();
    // initMessaging();
    super.initState();
    checkId(); 
    }

  int price = 0;

  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 7200;
  DateTime time = DateTime.now();
  bool isLoaded = false;

  List<String> exclusiveImage = ['images/girl.png', 'images/cosmetics.png', 'images/man.png', 'images/kid.png'];
  List<String> exclusiveName = ['Women', 'Cosmetics', 'Men', 'Kids'];
  bool isSearch = true;

  int count = 7;
  bool showmore = false;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Consumer(builder: (_, ref, __) {
        final newProduct = ref.watch(getProductOfSingleCategory(newArrive));
        final bestSellingProducts = ref.watch(getProductOfSingleCategory(bestSellingId));
        final trendingProducts = ref.watch(getProductOfSingleCategory(trendingProductsId));
        final recommendedProducts = ref.watch(getProductOfSingleCategory(recommendedProductId));
        final specialOffers = ref.watch(getProductOfSingleCategory(specialOffersID));
        final allCategory = ref.watch(getAllCategories);
        final allBanner = ref.watch(getBanner);
        final allCoupons = ref.watch(getCoupon);

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            titleSpacing: 0.0,
            
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchProductScreen()));
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primaryContainer,
                    prefixIcon: Icon(
                      IconlyLight.search,
                      color: isDark ? darkGreyTextColor : lightGreyTextColor,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(30)),
                    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: primaryColor), borderRadius: BorderRadius.circular(30)),
                    hintText: 'Search by Type Number...',
                    hintStyle: kTextStyle.copyWith(color: isDark ? darkGreyTextColor : lightGreyTextColor)),
              ),
            ),
            // actions:  const [
            //   Padding(
            //     padding: EdgeInsets.all(6.0),
            //     child: SwitchButton(),
            //   )
            // ],
            actions: [
  Padding(
    padding: EdgeInsets.all(6.0),
    // child: SwitchButton(),
  ),
 Padding(
  padding: EdgeInsets.all(6.0),
  child: Row(
    children: [
      ElevatedButton(
        onPressed: () {
          launch('tel:+251913918821');
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF000080),
        ),
        child: Icon(
          Icons.call,
          color: Colors.white,
        ),
      ),
      SizedBox(width: 6.0),
      ElevatedButton(
        onPressed: () {
        //  launch('https://t.me/nuru881'); 
         launch('sms:+251913918821');
       //  launch('https://wa.me/+251966202667');
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
        ),
        child: Icon(
          Icons.message,
          color: Colors.white,
        ),
      ),
    ],
  ),
)

],
          ),

          drawer: Drawer(
  child: Container(
    child: Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              // DrawerHeader(
              //   child: Center(
              //     child: Image(
              //       image: AssetImage('images/lead.png'),
              //       width: 500, // Increase the width to your desired size
              //       height: 500, // Increase the height to your desired size
              //     ),
              //   ),
                
              // ),

              DrawerHeader(
                child: Column(
                  children: [
                    Center(
                      child: Image(
                        image: AssetImage('images/lead.jpg'),
                        width: 100, // Increase the width to your desired size
                        height: 100, // Increase the height to your desired size
                      ),
                    ),
                    Text(
                      "Ethio Spare Market",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000080),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.cartPlus),
                title: Text("Profile", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => customerId != 0 ? const ProfileScreen() : const SignUp(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.cartPlus),
                title: Text("Cart", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.clock),
                title: Text("Orders", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => customerId != 0 ? const MyOrderScreen() : const SignUp(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.language),
                title: Text("Language", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LanguageScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.phoneVolume),
                title: Text("Contact Us", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ContactUsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text("Privacy Policy", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ContactUsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.note_add_outlined),
                title: Text("Terms & Conditions", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ContactUsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        customerId != 0 ?
        Container(
          margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                 final prefs = await SharedPreferences.getInstance();
                              await prefs.remove('customerId');
                              if (!mounted) return;
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const SplashScreenOne()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: Text(
                "Sign Out",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ) :
         Container(
  margin: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
  decoration: BoxDecoration(
    color: Color(0xFF000080),
    borderRadius: BorderRadius.circular(5),
  ),
  child: SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignUp(),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color(0xFF000080)),
      ),
      child: Text(
        "Sign Up",
        style: TextStyle(color: Colors.white),
      ),
    ),
  ),
),
      ],
    ),
  ),
),

          body: SingleChildScrollView(
            child: Column(
              children: [
                /// Build Horizontal List widget without giving specific height to it.
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: allBanner.when(data: (snapShot) {
//                     return ImageSlideshow(
//                         width: double.infinity,
//                         indicatorBackgroundColor: primaryColor.withOpacity(0.5),
//                         indicatorRadius: 4,
//                         isLoop: true,
//                         autoPlayInterval: 3000,
//                         indicatorColor: primaryColor,
//                         children: List.generate(snapShot.length, (index) {



//                            CachedNetworkImage(
//   imageUrl: snapShot[index].guid!.rendered.toString(),
//   imageBuilder: (context, imageProvider) => GestureDetector(
   
//     child: Container(
//                             height: 252,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.fill, image:imageProvider)),
//                           ),
//   ),
//   placeholder: (context, url) => Container(
//     alignment: Alignment.center,
//     child: CircularProgressIndicator(),
//   ),
//   errorWidget: (context, url, error) => Image.asset("images/store.png"),
// );
                          

                          

                          
//                       //  }));

                          
//                         //   return Container(
//                         //     height: 252,
//                         //     width: double.infinity,
//                         //     decoration: BoxDecoration(
//                         //         borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(snapShot[index].guid!.rendered.toString()))),
//                         //   );
//                         // }));
//           //               children: [
//           //   Image.asset(
//           //     'images/slider-1.jpg',
//           //     fit: BoxFit.cover,
//           //   ),
//           //   Image.asset(
//           //     'images/slider-2.jpg',
//           //     fit: BoxFit.cover,
//           //   ),
//           //   Image.asset(
//           //     'images/slider-3.jpg',
//           //     fit: BoxFit.cover,
//           //   ),
//           // ],

//         //  );
//                   }, error: (e, stack) {
//                     return Text(e.toString());
//                   }, loading: () {
//                     return const BannerShimmerWidget();
//                   }
//                   ),
//                 ),

Padding(
  padding: const EdgeInsets.all(15.0),
  child: allBanner.when(
    data: (snapShot) {
      return ImageSlideshow(
        width: double.infinity,
        indicatorBackgroundColor: primaryColor.withOpacity(0.5),
        indicatorRadius: 4,
        isLoop: true,
        autoPlayInterval: 3000,
        indicatorColor: primaryColor,
        children: [
          for (var index = 0; index < snapShot.length; index++)
            Container(
              height: 252,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: snapShot[index].guid!.rendered.toString(),
                fit: BoxFit.fill,
                placeholder: (context, url) {
                  if (index == 0) {
                    return Image.asset("images/slider-1.jpg");
                  } else if (index == 1) {
                    return Image.asset("images/slider-2.jpg");
                  } else if (index == 2) {
                    return Image.asset("images/slider-3.jpg");
                  } else {
                    return Container();
                  }
                },
                errorWidget: (context, url, error) => Image.asset("images/slider-1.jpg"),
              ),
            ),
        ],
      );
    },
    error: (e, stack) {
      return Text(e.toString());
    },
    loading: () {
      return const BannerShimmerWidget();
    },
  ),
),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          ///___________Category__________________________________________
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Image.asset(
                                    //   'images/bc.png',
                                    //   width: 140,
                                    //   color: isDark ? darkContainer : const Color(0xffF4EBFF),
                                    // ),
                                    // MyGoogleText(
                                    //   text: lang.S.of(context).categories,
                                    //   fontSize: 20,
                                    //   fontColor: isDark ? darkTitleColor : lightTitleColor,
                                    //   fontWeight: FontWeight.bold,
                                    // ),
                                    // TextButton(
                                    //   onPressed: () {
                                    //     const CategoryScreen().launch(context);
                                    //   },
                                    //   child: MyGoogleText(
                                    //     text: lang.S.of(context).showAll,
                                    //     fontSize: 13,
                                    //     fontColor: textColors,
                                    //     fontWeight: FontWeight.normal,
                                    //   ),
                                    // )
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                allCategory.when(data: (snapShot) {
                                  return Column(
                                    children: [
                                       Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            'images/bc2.png',
                                            width: 180,
                                            color: isDark ? darkContainer : Color(0xFF000080),
                                          ),
                                          Text(
                                            lang.S.of(context).Brands,
                                            style: kTextStyle.copyWith(fontSize: 20, color: isDark ? darkTitleColor : Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      _buildCategoryList2(snapShot),
                                      const SizedBox(height: 10.0),

                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            'images/bc2.png',
                                            width: 180,
                                            color: isDark ? darkContainer : Color(0xFF000080),
                                          ),
                                          Text(
                                            lang.S.of(context).yourCar,
                                            style: kTextStyle.copyWith(fontSize: 20, color: isDark ? darkTitleColor : Colors.white, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      _buildCategoryList3(snapShot),


                                      

                                      
                                     
                                    ],
                                  );
                                }, error: (e, stack) {
                                  return Text(e.toString());
                                }, loading: () {
                                  return Column(
                                    children: [
                                      HorizontalList(
                                          padding: EdgeInsets.zero,
                                          spacing: 10.0,
                                          itemCount: 5,
                                          itemBuilder: (_, i) {
                                            return Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor: Colors.grey.shade100,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.only(left: 5.0, right: 10.0, top: 5.0, bottom: 5.0),
                                                      height: 60.0,
                                                      width: 60.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(50),
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Container(
                                                      height: 12.0,
                                                      width: 60.0,
                                                      decoration: BoxDecoration(
                                                          color: black,
                                                          borderRadius: BorderRadius.circular(
                                                            30.0,
                                                          )),
                                                    ),
                                                  ],
                                                ));
                                          }),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),

                          ///-----------------Exclusive_for_you_____________________________
                          const SizedBox(
                            height: 20,
                          ),
                         Padding(
                           padding: const EdgeInsets.only(left: 10),
                           child: Column(
                             children: [

                               ///___________Offers__________________________________________
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Flexible(
                                     child: Text(
                                       lang.S.of(context).specialOffer,
                                       overflow: TextOverflow.ellipsis,
                                       maxLines: 1,
                                       style: kTextStyle.copyWith(
                                         fontSize: 18,
                                         color: isDark ? darkTitleColor : lightTitleColor,
                                         fontWeight: FontWeight.bold,
                                       ),
                                     ),
                                   ),

                                   ///____countDown_timer___________________________________
                                   CountdownTimer(
                                     endTime: endTime,
                                     widgetBuilder: (_, time) {
                                       if (time == null) {
                                         return Padding(
                                           padding: const EdgeInsets.only(right: 10),
                                           child: Text(
                                             lang.S.of(context).closingTime,
                                           ),
                                         );
                                       }
                                       return Row(
                                         children: [
                                           MyGoogleText(
                                             text: lang.S.of(context).closingTime,
                                             fontSize: 13,
                                             fontColor: isDark ? darkGreyTextColor : lightGreyTextColor,
                                             fontWeight: FontWeight.normal,
                                           ),
                                           const SizedBox(width: 5),
                                           Container(
                                             height: 25,
                                             width: 25,
                                             decoration: const BoxDecoration(
                                               color: primaryColor,
                                               borderRadius: BorderRadius.all(
                                                 Radius.circular(5),
                                               ),
                                             ),
                                             child: Center(
                                               child: MyGoogleText(
                                                 text: time.hours.toString(),
                                                 fontSize: 14,
                                                 fontColor: Colors.white,
                                                 fontWeight: FontWeight.bold,
                                               ),
                                             ),
                                           ),
                                           const SizedBox(width: 5),
                                           Container(
                                             height: 25,
                                             width: 25,
                                             decoration: const BoxDecoration(
                                               color: primaryColor,
                                               borderRadius: BorderRadius.all(
                                                 Radius.circular(5),
                                               ),
                                             ),
                                             child: Center(
                                               child: MyGoogleText(
                                                 text: time.min.toString(),
                                                 fontSize: 14,
                                                 fontColor: Colors.white,
                                                 fontWeight: FontWeight.bold,
                                               ),
                                             ),
                                           ),
                                           const SizedBox(width: 5),
                                           Container(
                                             height: 25,
                                             width: 25,
                                             decoration: const BoxDecoration(
                                               color: primaryColor,
                                               borderRadius: BorderRadius.all(
                                                 Radius.circular(5),
                                               ),
                                             ),
                                             child: Center(
                                               child: MyGoogleText(
                                                 text: time.sec.toString(),
                                                 fontSize: 14,
                                                 fontColor: Colors.white,
                                                 fontWeight: FontWeight.bold,
                                               ),
                                             ),
                                           ),
                                           const SizedBox(width: 10),
                                         ],
                                       );
                                     },
                                   ),
                                 ],
                               ),
                               const SizedBox(height: 10),
                               specialOffers.when(data: (snapShot) {
                                 return HorizontalList(
                                   itemCount: snapShot.length > 6 ? 6 : snapShot.length,
                                   spacing: 10,
                                   itemBuilder: (BuildContext context, int index) {
                                     final productVariation = ref.watch(getSingleProductVariation(snapShot[index].id!.toInt()));

                                     return productVariation.when(data: (snapData) {
                                       if (snapShot[index].type != 'simple' && snapData.isNotEmpty) {
                                         return GestureDetector(
                                           onTap: () {
                                             ProductDetailScreen(
                                               singleProductsVariation: snapData[index],
                                               productModel: snapShot[index],
                                               categoryId: specialOffersID,
                                             ).launch(context);
                                           },
                                           child: Container(
                                             padding: const EdgeInsets.all(3),
                                             decoration: BoxDecoration(
                                               color: isDark ? cardColor : Colors.transparent,
                                               border: Border.all(
                                                 width: 1,
                                                 color: isDark ? darkContainer : secondaryColor3,
                                               ),
                                               borderRadius: const BorderRadius.all(
                                                 Radius.circular(8),
                                               ),
                                             ),
                                             child: Column(
                                               children: [
                                                //  Container(
                                                //    height: 100,
                                                //    width: 128,
                                                //    decoration: BoxDecoration(
                                                //      image: DecorationImage(
                                                //        image: NetworkImage(
                                                //          snapShot[index].images![0].src.toString(),
                                                //        ),
                                                //        fit: BoxFit.cover,
                                                //      ),
                                                //      borderRadius: const BorderRadius.all(
                                                //        Radius.circular(8),
                                                //      ),
                                                //    ),
                                                //  ),

                                                // CachedNetworkImage(
                                                //     imageUrl: snapShot[index].images![0].src.toString(),
                                                //     imageBuilder: (context, imageProvider) => Container(
                                                //       height: 100,
                                                //       width: 128,
                                                //       decoration: BoxDecoration(
                                                //       image: DecorationImage(
                                                //        image: imageProvider,
                                                //        fit: BoxFit.cover,
                                                //        ),
                                                //        borderRadius: const BorderRadius.all(
                                                //         Radius.circular(8),
                                                //         ),
                                                //       ),
                                                //     ),
                                                //      placeholder: (context, url) => Container(
                                                //      height: 100,
                                                //      width: 128,
                                                //        decoration: BoxDecoration(
                                                //         color: Colors.grey, // Placeholder color
                                                //         borderRadius: const BorderRadius.all(
                                                //         Radius.circular(8),
                                                //             ),
                                                //               ),
                                                //         child: Center(
                                                //             child: CircularProgressIndicator(),
                                                //              ),
                                                //            ),
                                                //          errorWidget: (context, url, error) => Container(
                                                //          height: 100,
                                                //          width: 128,
                                                //          decoration: BoxDecoration(
                                                //          color: Colors.grey, // Error widget color
                                                //          borderRadius: const BorderRadius.all(
                                                //          Radius.circular(8),
                                                //             ),
                                                //          ),
                                                //          child: Icon(Icons.error),
                                                //              ),
                                                //          ),

                                                 Padding(
                                                   padding: const EdgeInsets.all(5.0),
                                                   child: SizedBox(
                                                     width: 120,
                                                     child: Text(
                                                       snapShot[index].name.toString(),
                                                       maxLines: 1,
                                                       overflow: TextOverflow.ellipsis,
                                                       style: GoogleFonts.dmSans(color: isDark ? darkTitleColor : lightTitleColor),
                                                     ),
                                                   ),
                                                 ),
                                                 Padding(
                                                   padding: const EdgeInsets.only(bottom: 8),
                                                   child: MyGoogleText(
                                                     text: snapShot[index].type == 'simple' ? '\$ ${snapShot[index].salePrice}' : '\$ ${snapData[0].salePrice}',
                                                     fontSize: 14,
                                                     fontColor: isDark ? darkTitleColor : lightTitleColor,
                                                     fontWeight: FontWeight.w600,
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ),
                                         );
                                       } else {
                                         return GestureDetector(
                                           onTap: () {
                                             ProductDetailScreen(
                                               productModel: snapShot[index],
                                               categoryId: specialOffersID,
                                             ).launch(context);
                                           },
                                           child: Container(
                                             padding: const EdgeInsets.all(3),
                                             decoration: BoxDecoration(
                                               color: Colors.transparent,
                                               border: Border.all(
                                                 width: 1,
                                                 color: secondaryColor3,
                                               ),
                                               borderRadius: const BorderRadius.all(
                                                 Radius.circular(8),
                                               ),
                                             ),
                                             child: Column(
                                               children: [
                                                //  Container(
                                                //    height: 100,
                                                //    width: 128,
                                                //    decoration: BoxDecoration(
                                                //      image: DecorationImage(
                                                //        image: NetworkImage(
                                                //          snapShot[index].images![0].src.toString(),
                                                //        ),
                                                //        fit: BoxFit.cover,
                                                //      ),
                                                //      borderRadius: const BorderRadius.all(
                                                //        Radius.circular(8),
                                                //      ),
                                                //    ),
                                                //  ),

                                                CachedNetworkImage(
  imageUrl: snapShot[index].images![0].src.toString(),
  imageBuilder: (context, imageProvider) => GestureDetector(
   
    child: Container(
      width: 200, // Updated width
      height: 100, // Updated height
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.fitWidth,
        ),
      ),
    ),
  ),
  placeholder: (context, url) => Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(),
  ),
  errorWidget: (context, url, error) => Image.asset("images/store.png"),
),


                                                 Padding(
                                                   padding: const EdgeInsets.all(5.0),
                                                   child: SizedBox(
                                                     width: 120,
                                                     child: Text(
                                                       snapShot[index].name.toString(),
                                                       maxLines: 1,
                                                       overflow: TextOverflow.ellipsis,
                                                       style: GoogleFonts.dmSans(),
                                                     ),
                                                   ),
                                                 ),
                                                 Padding(
                                                   padding: const EdgeInsets.only(bottom: 8),
                                                   child: MyGoogleText(
                                                     text: snapShot[index].type == 'simple'
                                                         ? snapShot[index].salePrice.toInt() <= 0
                                                         ? '\$ ${snapShot[index].regularPrice}'
                                                         : '\$${snapShot[index].salePrice}'
                                                         : snapData[0].salePrice!.toInt() <= 0
                                                         ? '\$${snapData[0].regularPrice}'
                                                         : '\$${snapData[0].salePrice}',
                                                     fontSize: 14,
                                                     fontColor: isDark ? darkTitleColor : lightTitleColor,
                                                     fontWeight: FontWeight.w600,
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ),
                                         );
                                       }
                                     }, error: (e, stack) {
                                       return Text(e.toString());
                                     }, loading: () {
                                       return Container();
                                     });
                                   },
                                 );
                               }, error: (e, stack) {
                                 return Text(e.toString());
                               }, loading: () {
                                 return const Center(child: ProductShimmerWidget());
                               }),
                               const SizedBox(height: 10),

                               ///__________Trending_Products_________________________________________
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text(
                                     lang.S.of(context).Toyota,
                                     overflow: TextOverflow.ellipsis,
                                     maxLines: 1,
                                     style: kTextStyle.copyWith(
                                       fontSize: 16,
                                       color: isDark ? darkTitleColor : lightTitleColor,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                   
                                   Flexible(
                                     child: TextButton(
                                       onPressed: () {
                                         SingleCategoryScreen(
                                           categoryId: trendingProductsId,
                                           categoryName: lang.S.of(context).trendingFashion,
                                           categoryList: const [],
                                           categoryModel: CategoryModel(),
                                         ).launch(context);
                                       },
                                       child: Text(
                                         lang.S.of(context).showAll,
                                         overflow: TextOverflow.ellipsis,
                                         maxLines: 1,
                                         style: kTextStyle.copyWith(
                                           fontSize: 13,
                                           color: primaryColor,
                                           fontWeight: FontWeight.normal,
                                         ),
                                       ),
                                     ),
                                   )
                                 ],
                               ),

                               trendingProducts.when(data: (snapShot) {
                                 return HorizontalList(
                                  
                                     spacing: 0,
                                     itemCount: snapShot.length > 6 ? 6 : snapShot.length,
                                     itemBuilder: (_, index) {
                                       final productVariation = ref.watch(getSingleProductVariation(snapShot[index].id!.toInt()));

                                       return productVariation.when(data: (dataSnap) {
                                         if (snapShot[index].type != 'simple' && dataSnap.isNotEmpty) {
                                           int discount = discountGenerator(dataSnap[0].regularPrice.toString(), dataSnap[0].salePrice.toString());
                                           return Padding(
                                             padding: const EdgeInsets.only(right: 15),
                                             child: ProductGreedShow(
                                               singleProductVariations: dataSnap[0],
                                               productModel: snapShot[index],
                                               discountPercentage: discount.toString(),
                                               isSingleView: false,
                                               categoryId: trendingProductsId,
                                             ),
                                           );
                                         } else {
                                           int discount = discountGenerator(snapShot[index].regularPrice.toString(), snapShot[index].salePrice.toString());
                                           return Padding(
                                             padding: const EdgeInsets.only(right: 15),
                                             child: ProductGreedShow(
                                               productModel: snapShot[index],
                                               discountPercentage: discount.toString(),
                                               isSingleView: false,
                                               categoryId: trendingProductsId,
                                             ),
                                           );
                                         }
                                       }, error: (e, stack) {
                                         return Text(e.toString());
                                       }, loading: () {
                                         return Container();
                                       });
                                     });
                               }, error: (e, stack) {
                                 return Text(e.toString());
                               }, loading: () {
                                 return const Center(child: ProductShimmerWidget());
                               }),
                               const SizedBox(
                                 height: 10,
                               ),

                               ///-----------------Recomanded--------------
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   MyGoogleText(
                                     text: lang.S.of(context).Honda,
                                     fontSize: 16,
                                     fontColor: isDark ? darkTitleColor : lightTitleColor,
                                     fontWeight: FontWeight.bold,
                                   ),
                                   Flexible(
                                     child: TextButton(
                                       onPressed: () {
                                         SingleCategoryScreen(
                                           categoryId: recommendedProductId,
                                           categoryName: lang.S.of(context).trendingFashion,
                                           categoryList: const [],
                                           categoryModel: CategoryModel(),
                                         ).launch(context);
                                       },
                                       child: Text(
                                         lang.S.of(context).showAll,
                                         overflow: TextOverflow.ellipsis,
                                         maxLines: 1,
                                         style: kTextStyle.copyWith(
                                           fontSize: 13,
                                           color: primaryColor,
                                           fontWeight: FontWeight.normal,
                                         ),
                                       ),
                                     ),
                                   )
                                 ],
                               ),
                               recommendedProducts.when(data: (snapShot) {
                                 return HorizontalList(
                                     spacing: 0,
                                     itemCount: snapShot.length > 6 ? 6 : snapShot.length,
                                     itemBuilder: (_, index) {
                                       final productVariation = ref.watch(getSingleProductVariation(snapShot[index].id!.toInt()));

                                       return productVariation.when(data: (dataSnap) {
                                         if (snapShot[index].type != 'simple' && dataSnap.isNotEmpty) {
                                           int discount = discountGenerator(dataSnap[0].regularPrice.toString(), dataSnap[0].salePrice.toString());
                                           return Padding(
                                             padding: const EdgeInsets.only(right: 15),
                                             child: ProductGreedShow(
                                               singleProductVariations: dataSnap[0],
                                               productModel: snapShot[index],
                                               discountPercentage: discount.toString(),
                                               isSingleView: false,
                                               categoryId: recommendedProductId,
                                             ),
                                           );
                                         } else {
                                           int discount = discountGenerator(snapShot[index].regularPrice.toString(), snapShot[index].salePrice.toString());
                                           return Padding(
                                             padding: const EdgeInsets.only(right: 15),
                                             child: ProductGreedShow(
                                               productModel: snapShot[index],
                                               discountPercentage: discount.toString(),
                                               isSingleView: false,
                                               categoryId: recommendedProductId,
                                             ),
                                           );
                                         }
                                       }, error: (e, stack) {
                                         return Text(e.toString());
                                       }, loading: () {
                                         return Container();
                                       });
                                     });
                               }, error: (e, stack) {
                                 return Text(e.toString());
                               }, loading: () {
                                 return const Center(child: ProductShimmerWidget());
                               }),
                               const SizedBox(
                                 height: 10,
                               ),

                               ///-----------------Best_sales--------------
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   MyGoogleText(
                                     text: lang.S.of(context).Hondai,
                                     fontSize: 16,
                                     fontColor: isDark ? darkTitleColor : lightTitleColor,
                                     fontWeight: FontWeight.bold,
                                   ),
                                   TextButton(
                                     onPressed: () {
                                       SingleCategoryScreen(
                                         categoryId: bestSellingId,
                                         categoryName: lang.S.of(context).BMW,
                                         categoryList: const [],
                                         categoryModel: CategoryModel(),
                                       ).launch(context);
                                     },
                                     child: MyGoogleText(
                                       text: lang.S.of(context).showAll,
                                       fontSize: 13,
                                       fontColor: primaryColor,
                                       fontWeight: FontWeight.normal,
                                     ),
                                   )
                                 ],
                               ),
                               bestSellingProducts.when(data: (snapShot) {
                                 return HorizontalList(
                                     spacing: 0,
                                     itemCount: snapShot.length > 6 ? 6 : snapShot.length,
                                     itemBuilder: (_, index) {
                                       final productVariation = ref.watch(getSingleProductVariation(snapShot[index].id!.toInt()));

                                       return productVariation.when(data: (dataSnap) {
                                         if (snapShot[index].type != 'simple' && dataSnap.isNotEmpty) {
                                           int discount = discountGenerator(dataSnap[0].regularPrice.toString(), dataSnap[0].salePrice.toString());
                                           return Padding(
                                             padding: const EdgeInsets.only(right: 15),
                                             child: ProductGreedShow(
                                               singleProductVariations: dataSnap[0],
                                               productModel: snapShot[index],
                                               discountPercentage: discount.toString(),
                                               isSingleView: false,
                                               categoryId: bestSellingId,
                                             ),
                                           );
                                         } else {
                                           int discount = discountGenerator(snapShot[index].regularPrice.toString(), snapShot[index].salePrice.toString());
                                           return Padding(
                                             padding: const EdgeInsets.only(right: 15),
                                             child: ProductGreedShow(
                                               productModel: snapShot[index],
                                               discountPercentage: discount.toString(),
                                               isSingleView: false,
                                               categoryId: bestSellingId,
                                             ),
                                           );
                                         }
                                       }, error: (e, stack) {
                                         return Text(e.toString());
                                       }, loading: () {
                                         return Container();
                                       });
                                     });
                               }, error: (e, stack) {
                                 return Text(e.toString());
                               }, loading: () {
                                 return const Center(child: ProductShimmerWidget());
                               }),
                               const SizedBox(
                                 height: 10,
                               ),

                               ///___________Promo__________________________________________

                               allCoupons.when(data: (snapShot) {
                                 return Padding(
                                   padding: const EdgeInsets.only(right: 8,top: 8,bottom: 8),
                                   child: HorizontalList(
                                     padding: EdgeInsets.zero,
                                     spacing: 10.0,
                                     itemCount: snapShot.length > 6 ? 6 : snapShot.length,
                                     itemBuilder: (_, i) {
                                       return Container(
                                         height: 130,
                                         width: context.width() / 1.05,
                                         decoration: BoxDecoration(
                                           image: DecorationImage(image: AssetImage(HardcodedImages.couponBackgroundImage), fit: BoxFit.fill),
                                           borderRadius: const BorderRadius.all(
                                             Radius.circular(15),
                                           ),
                                         ),
                                         child: Column(
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           children: [
                                             MyGoogleText(
                                               text: '${snapShot[i].amount}% OFF',
                                               fontSize: 24,
                                               fontColor: Colors.white,
                                               fontWeight: FontWeight.normal,
                                             ),
                                             const SizedBox(height: 10),
                                             MyGoogleText(
                                               text: 'USE CODE: ${snapShot[i].code.toString()}',
                                               fontSize: 16,
                                               fontColor: Colors.white,
                                               fontWeight: FontWeight.normal,
                                             ),
                                           ],
                                         ),
                                       );
                                     },
                                   ),
                                 );
                               }, error: (e, stack) {
                                 return Text(e.toString());
                               }, loading: () {
                                 return const BannerShimmerWidget();
                               }),

                               ///___________New_Arrivals__________________________________________
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   MyGoogleText(
                                     text: lang.S.of(context).Nissan,
                                     fontSize: 16,
                                     fontColor: isDark ? darkTitleColor : lightTitleColor,
                                     fontWeight: FontWeight.bold,
                                   ),
                                   TextButton(
                                     onPressed: () {
                                       SingleCategoryScreen(
                                         categoryId: newArrive,
                                         categoryName: lang.S.of(context).newArrival,
                                         categoryList: const [],
                                         categoryModel: CategoryModel(),
                                       ).launch(context);
                                     },
                                     child: MyGoogleText(
                                       text: lang.S.of(context).showAll,
                                       fontSize: 13,
                                       fontColor: primaryColor,
                                       fontWeight: FontWeight.normal,
                                     ),
                                   )
                                 ],
                               ),

                               newProduct.when(data: (snapShot) {
                                 return HorizontalList(
                                     itemCount: snapShot.length > 6 ? 6 : snapShot.length,
                                     spacing: 0,
                                     itemBuilder: (_, index) {
                                       final productVariation = ref.watch(getSingleProductVariation(snapShot[index].id!.toInt()));

                                       return productVariation.when(data: (dataSnap) {
                                         if (snapShot[index].type != 'simple' && dataSnap.isNotEmpty) {
                                           int discount = discountGenerator(dataSnap[0].regularPrice.toString(), dataSnap[0].salePrice.toString());
                                           return Padding(
                                             padding: const EdgeInsets.only(right: 15),
                                             child: ProductGreedShow(
                                               singleProductVariations: dataSnap[0],
                                               productModel: snapShot[index],
                                               discountPercentage: discount.toString(),
                                               isSingleView: false,
                                               categoryId: newArrive,
                                             ),
                                           );
                                         } else {
                                           int discount = discountGenerator(snapShot[index].regularPrice.toString(), snapShot[index].salePrice.toString());
                                           return Padding(
                                             padding: const EdgeInsets.only(right: 15),
                                             child: ProductGreedShow(
                                               productModel: snapShot[index],
                                               discountPercentage: discount.toString(),
                                               isSingleView: false,
                                               categoryId: newArrive,
                                             ),
                                           );
                                         }
                                       }, error: (e, stack) {
                                         return Text(e.toString());
                                       }, loading: () {
                                         return Container();
                                       });
                                     });
                               }, error: (e, stack) {
                                 return Text(e.toString());
                               }, loading: () {
                                 return const Center(child: ProductShimmerWidget());
                               }),

                               Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      height: 1,
      color: Colors.grey[300],
    ),

    // Footer
    // Footer with clickable text
    GestureDetector(
      onTap: () {
        // Open URL when clicked
        launch('https://addisway.com/');
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
            children: [
              TextSpan(
                text: 'developed by ',
              ),
              TextSpan(
                text: 'Addisway Technology Solution',
                style: TextStyle(
                  color: Color(0xFF000080),// Set the word "Addisway" color to blue
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  
  
  
                              
                             ],
                           ),
                         )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  int discountGenerator(String regularPrice, String sellingPrice) {
    double discount;

    if (regularPrice.isEmpty || sellingPrice.isEmpty) {
      return 202;
    } else {
      discount = ((double.parse(sellingPrice) * 100) / double.parse(regularPrice)) - 100;
    }

    return discount.toInt();
  }

  Widget _buildCategoryList(List<CategoryModel> categories) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<CategoryModel> finalList = [];
    final List<CategoryModel> allSubCategoryList = [];
    for (var element in categories) {
      if (element.parent != 0) {
      finalList.length <8 ? {finalList.add(element),allSubCategoryList.add(element)} : allSubCategoryList.add(element);
      }
    }
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 5, childAspectRatio: 0.72, crossAxisSpacing: 8),
      itemCount: finalList.length,
      itemBuilder: (context, index) {
        String? image = finalList[index].image?.src.toString();
        return InkWell(
          onTap: () {
            index >= 7
                ? Navigator.push(context, MaterialPageRoute(builder: (context) =>  CategoryScreen(allSubCategoryList: allSubCategoryList,)))
                : SingleCategoryScreen(
                    categoryId: finalList[index].id!.toInt(),
                    categoryName: finalList[index].name.toString(),
                    categoryList: categories,
                    categoryModel: finalList[index],
                  ).launch(context);
          },
          child: index >= 7
              ? Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 75,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(image??''),
                              ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: Container(
                                    color: Colors.grey.withOpacity(0.1),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          CommunityMaterialIcons.dots_horizontal_circle_outline,
                          color: Colors.white,
                          size: 50,
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View More',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kTextStyle.copyWith(fontSize: 12, color: isDark ? darkTitleColor : lightTitleColor),
                    )
                  ],
                )
              : Column(
                  children: [
                    Container(height: 75, width: 75, decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(image ?? '')))),
                    const SizedBox(height: 4),
                    Text(
                      // finalList[index].name.toString(),
                      "testttt",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kTextStyle.copyWith(fontSize: 12, color: isDark ? darkTitleColor : lightTitleColor),
                    )
                  ],
                ),
        );
      },
    );
  }



  Widget _buildCategoryList2(List<CategoryModel> categories) {
  final List<CategoryModel> finalList = [];
  for (var element in categories) {
    if (element.parent == 0 && element.id! < 30) {
      finalList.length < 9 ? finalList.add(element) : null;
    }
  }

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (int i = 0; i < finalList.length; i++)
          if (finalList[i].id != 15) // Exclude items with ID number 15
            Padding(
              padding: const EdgeInsets.only(left: 9, right: 9),
              child: CachedNetworkImage(
                imageUrl: finalList[i].image?.src ?? '',
                imageBuilder: (context, imageProvider) => GestureDetector(
                  onTap: () {
                    SingleCategoryScreen(
                      categoryId: finalList[i].id!.toInt(),
                      categoryName: finalList[i].name.toString(),
                      categoryList: finalList,
                      categoryModel: finalList[i],
                    ).launch(context);
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Image.asset("images/spare.png"),
              ),
            ),
      ],
    ),
  );
}





 Widget _buildCategoryList3(List<CategoryModel> categories) {
  final List<CategoryModel> finalList = [];
  for (var element in categories) {
    if (element.parent == 0 && element.id! > 30 && element.id != 323) {
      finalList.length < 9 ? finalList.add(element) : null;
    }
  }

  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: (finalList.length / 3).ceil(),
      itemBuilder: (context, rowIndex) {
        int startIndex = rowIndex * 3;
        int endIndex = (rowIndex + 1) * 3;
        if (endIndex > finalList.length) endIndex = finalList.length;

        List<CategoryModel> rowItems = finalList.sublist(startIndex, endIndex);

        return Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: 9,
              mainAxisSpacing: 9,
            ),
            itemCount: rowItems.length,
            itemBuilder: (context, columnIndex) {
              int imageIndex = columnIndex % rowItems.length; // Calculate the cyclic index
              CategoryModel item = rowItems[imageIndex];
              return Column(
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: item.image?.src ?? '',
                      imageBuilder: (context, imageProvider) => GestureDetector(
                        onTap: () {
                          SingleCategoryScreen(
                            categoryId: item.id!.toInt(),
                            categoryName: item.name.toString(),
                            categoryList: finalList,
                            categoryModel: item,
                          ).launch(context);
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Image.asset("images/spare.png"),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    item.name.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        );
      },
    ),
  );
}

// Widget _buildCategoryList3(List<CategoryModel> categories) {
//   final List<CategoryModel> finalList = [];
//   for (var element in categories) {
//     if (element.parent == 0) {
//       if (finalList.length < 9) {
//         finalList.add(element);
//       }
//     }
//   }

//   return SingleChildScrollView(
//     scrollDirection: Axis.horizontal,
//     child: Row(
//       children: [
//         for (int i = 0; i < finalList.length; i++)
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 9),
//                 child: GestureDetector(
//                   onTap: () {
//                     SingleCategoryScreen(
//                       categoryId: finalList[i].id!.toInt(),
//                       categoryName: finalList[i].name.toString(),
//                       categoryList: finalList,
//                       categoryModel: finalList[i],
//                     ).launch(context);
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: CachedNetworkImageProvider(
//                           finalList[i].image?.src ?? '',
//                         ),
//                         fit: BoxFit.fitWidth,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//       ],
//     ),
//   );
// }

}
