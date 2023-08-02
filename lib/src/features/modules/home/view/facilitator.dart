import 'package:birds_learning_network/src/features/modules/home/custom_widgets/html_page.dart';
import 'package:birds_learning_network/src/features/modules/home/model/response_model/get_courses.dart';
import 'package:birds_learning_network/src/features/modules/home/view/widgets/facilitator/facilitator_course_card.dart';
import 'package:birds_learning_network/src/features/modules/home/view/widgets/shimmer/more_card_shimmer.dart';
import 'package:birds_learning_network/src/features/modules/home/view_model/facilitator_provider.dart';
import 'package:birds_learning_network/src/utils/global_constants/colors/colors.dart';
import 'package:birds_learning_network/src/utils/global_constants/styles/cart_styles/cart_styles.dart';
import 'package:birds_learning_network/src/utils/helper_widgets/leading_icon.dart';
import 'package:birds_learning_network/src/utils/mixins/module_mixins/facilitator_mixins.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class FacilitatorScreen extends StatefulWidget {
  const FacilitatorScreen({super.key});

  @override
  State<FacilitatorScreen> createState() => _FacilitatorScreenState();
}

class _FacilitatorScreenState extends State<FacilitatorScreen>
    with FacilitatorMixin {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<FacilitatorProvider>(context, listen: false).refreshData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        leading: leadingIcon(context),
        elevation: 0,
      ),
      body: Consumer<FacilitatorProvider>(
        builder: (_, facilitator, __) => SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: profilePicture(facilitator.imageUrl)),
                const SizedBox(height: 10),
                nameText(facilitator.name),
                labelText(facilitator.email),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleCard("About Me"),
                    const SizedBox(height: 10),
                    // labelText(facilitator.aboutMe)
                    HTMLPageScreen(
                      content: facilitator.aboutMe,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    cardText(
                        "Total Courses", facilitator.totalCourse.toString()),
                    cardText("Avg. Rating", facilitator.rating),
                    cardText("No. of Students", facilitator.studentNo),
                  ],
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleCard("Courses"),
                    const SizedBox(height: 15),
                    facilitator.courseList.isEmpty
                        ? facilitator.isLoading
                          ?  ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 8,
                              itemBuilder: (context, int index) {
                                return const MoreCardsShimmer();
                              })
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "No course available for this facilitator.",
                                  style: CartStyles.richStyle1,
                                ),
                              ),
                            )
                        : ListView.separated(
                            separatorBuilder: (context, index) => const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 7.5),
                                  child: Divider(
                                    color: success400,
                                    thickness: 0.7,
                                  ),
                                ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: facilitator.courseList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              facilitator.courseList[index].facilitator =
                                  Facilitator();
                              facilitator.courseList[index].facilitator!.name =
                                  facilitator.name;
                              facilitator.courseList[index].facilitator!
                                  .ratings = facilitator.rating;
                              return FacilitatorCourseCards(
                                  course: facilitator.courseList[index]);
                            }),
                  ],
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        )),
      ),
    );
  }
}
