import 'package:birds_learning_network/src/config/routing/route.dart';
import 'package:birds_learning_network/src/features/modules/home/custom_widgets/course_image.dart';
import 'package:birds_learning_network/src/features/modules/subscription/view/widget/subscription_tag.dart';
import 'package:birds_learning_network/src/features/modules/home/model/response_model/get_courses.dart';
import 'package:birds_learning_network/src/features/modules/home/view/buy_course_screen.dart';
import 'package:birds_learning_network/src/utils/global_constants/asset_paths/image_path.dart';
import 'package:birds_learning_network/src/utils/global_constants/colors/colors.dart';
import 'package:birds_learning_network/src/utils/helper_widgets/star_widget.dart';
import 'package:birds_learning_network/src/utils/mixins/module_mixins/home_mixins.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget with ImagePath, HomeWidgets {
  const CourseCard({
    super.key,
    required this.onFavPressed,
    required this.course,
    this.iconData = Icons.favorite_outline,
    this.iconColor = skipColor,
  });
  final VoidCallback onFavPressed;
  final Courses course;
  final Color iconColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        course.sections = <Sections>[];
        RoutingService.pushFullScreenRouting(
            context, BuyCourseScreen(course: course));
      },
      child: Container(
        width: 165,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: grey100,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: 90,
                width: 165,
                child: CourseImageWidget(imageUrl: course.imageUrl ?? "",)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width - (size.width * 0.08) - 60,
                    child: courseTitleText(course.title ?? ""),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ownerText(course.facilitator!.name == ""
                              ? "Anonymous"
                              : course.facilitator!.name!),
                          SizedBox(height: course.subscriptionBased != null &&  course.subscriptionBased! ? 8 : 5),
                          Row(
                            children: [
                              Row(
                                children: getStarList(
                                    course.facilitator!.ratings ?? "1",
                                    ImagePath.starFill,
                                    ImagePath.starUnfill),
                              ),
                              const SizedBox(width: 10),
                              ratingText(course.facilitator!.reviews.toString())
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: course.subscriptionBased != null &&  course.subscriptionBased! ? 8 : 5),
                      Container(
                        child: course.subscriptionBased ?? true ? null : IconButton(
                            onPressed: onFavPressed,
                            icon: Icon(
                              iconData,
                              color: iconColor,
                            )),
                      )
                    ],
                  ),
                  SizedBox(height: course.subscriptionBased != null &&  course.subscriptionBased! ? 8 : 5),
                  Container(
                      child: course.subscriptionBased != null &&  course.subscriptionBased!
                      ?  SubscriptionTagWidget(course: course)
                      :amountText(course.salePrice ?? "5000", course.price ?? "5500"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
