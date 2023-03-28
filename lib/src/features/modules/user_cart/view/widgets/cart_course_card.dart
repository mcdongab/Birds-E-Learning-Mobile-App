import 'package:birds_learning_network/src/config/routing/route.dart';
import 'package:birds_learning_network/src/features/modules/payment/view/screens/payment_screen.dart';
import 'package:birds_learning_network/src/features/modules/user_cart/view_model/cart_provider.dart';
import 'package:birds_learning_network/src/utils/global_constants/colors/colors.dart';
import 'package:birds_learning_network/src/utils/helper_widgets/star_widget.dart';
import 'package:birds_learning_network/src/utils/mixins/module_mixins/cart_mixins.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/global_constants/asset_paths/image_path.dart';
import '../../../home/model/response_model/get_courses.dart';

class CourseCartCards extends StatelessWidget with CartWidgets {
  const CourseCartCards({
    super.key,
    required this.course,
    this.isWishlist = false,
    required this.removeButton,
  });
  final Courses course;
  final bool isWishlist;
  final Widget removeButton;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer<CartProvider>(
      builder: (_, cart, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: CachedNetworkImage(
                  imageUrl: course.imageUrl ?? "",
                  placeholder: (context, url) {
                    return Image.asset(
                      ImagePath.titlePics,
                      fit: BoxFit.fill,
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      ImagePath.titlePics,
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width - (size.width * 0.08) - 60,
                    child: courseTitleText(
                        course.title ?? "Introduction to Technology"),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      ownerNameText(course.facilitator == null
                          ? "Anonymous"
                          : course.facilitator!.name!),
                      const SizedBox(width: 5),
                      Row(
                        children: getStarList(
                            "3", ImagePath.starFill, ImagePath.starUnfill),
                      ),
                      const SizedBox(width: 5),
                      ratingText(course.facilitator == null
                          ? "4"
                          : course.facilitator!.ratings.toString())
                    ],
                  ),
                  const SizedBox(height: 3),
                  amountText(
                      course.salePrice ?? "NGN5000", course.price ?? "NGN5500"),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: isWishlist
                            ? null
                            : addRemoveCart(
                                "Buy Now",
                                skipColor,
                                Icons.add,
                                () => RoutingService.pushRouting(
                                    context, const PaymentScreen())),
                      ),
                      SizedBox(width: isWishlist ? 0 : 15),
                      removeButton,
                      // isWishlist && cart.removeWishIcon
                      //     ? loadingIdicator()
                      //     : !isWishlist && cart.removeCartIcon
                      //         ? loadingIdicator()
                      // : addRemoveCart("Remove", errors500, Icons.remove,
                      //     onRemoveTap),
                    ],
                  )
                ],
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              thickness: 0.2,
              color: success1000,
            ),
          )
        ],
      ),
    );
  }
}
