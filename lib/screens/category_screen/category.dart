import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maanstore/models/category_model.dart';
import 'package:maanstore/screens/category_screen/single_category_screen.dart';
import 'package:maanstore/widgets/order_page_shimmer.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../const/constants.dart';
import '../../Providers/all_repo_providers.dart';
import '../../api_service/api_service.dart';
import '../../widgets/category_view.dart';
import '../Theme/theme.dart';
import '../search_product_screen.dart';
import 'package:maanstore/generated/l10n.dart'as lang;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late APIService apiService;

  @override
  void initState() {
    apiService = APIService();
    super.initState();
  }

  List<Color> colors = const [
    Color(0xFFFCF3D7),
    Color(0xFFDCF7E3),
    Color(0xFFFEE4E2),
    Color(0xFFE5EFFF),
    Color(0xFFDAF5F2),
  ];
  List<Color> colorsFinal = [];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer(builder: (_, ref, __) {
      final allCategory = ref.watch(getAllCategories);
      return Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: isDark?darkContainer:secondaryColor3,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: IconButton(
                    onPressed: () {
                      const SearchProductScreen().launch(context);
                    },
                    icon:  Icon(
                      FeatherIcons.search,
                      color: isDark ? darkTitleColor : lightTitleColor,
                    ),
                  ),
                ),
              ),
            ],
            leading: GestureDetector(
              onTap: () {
                finish(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: isDark ? darkTitleColor : lightTitleColor,
              ),
            ),
            title: MyGoogleText(
              text: lang.S.of(context).categories,
              fontColor: isDark ? darkTitleColor : lightTitleColor,
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration:  BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      allCategory.when(data: (snapShot) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapShot.length,
                          itemBuilder: (_, index) {
                            String? image = snapShot[index].image?.src.toString();
                            return Padding(
  padding: const EdgeInsets.only(bottom: 20.0),
  child: CategoryView(
    name: snapShot[index].name.toString(),
    items: '${snapShot[index].count} ${lang.S.of(context).cartItems}',
    color: colors[index % 5],
    image: image.toString(),
    onTabFunction: () {
      SingleCategoryScreen(
        categoryId: snapShot[index].id!.toInt(),
        categoryName: snapShot[index].name.toString(),
        categoryList: snapShot,
        categoryModel: snapShot[index],
      ).launch(context);
    },
    snapshot: AsyncValue<List<CategoryModel>>.data([]),
  ),
).visible(snapShot[index].parent != 0);
                          },
                        );
                      }, error: (e, stack) {
                        return Text(e.toString());
                      }, loading: () {
                        return const CategoryPageShimmer();
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
