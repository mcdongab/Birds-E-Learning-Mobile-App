import 'dart:async';

import 'package:birds_learning_network/src/features/core/settings/view_model/filter_provider.dart';
import 'package:birds_learning_network/src/features/modules/courses/view/course_screen.dart';
import 'package:birds_learning_network/src/features/modules/home/model/repository/home_repository.dart';
import 'package:birds_learning_network/src/features/modules/home/model/response_model/get_courses_pref.dart';
import 'package:birds_learning_network/src/features/modules/user_cart/view/cart.dart';
import 'package:birds_learning_network/src/features/modules/home/view/home_page.dart';
import 'package:birds_learning_network/src/features/modules/profile/view/profile_page.dart';
import 'package:birds_learning_network/src/global_model/services/storage/shared_preferences/user_details.dart';
import 'package:birds_learning_network/src/utils/helper_widgets/response_snack.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeProvider extends ChangeNotifier {
  HomeRepository repo = HomeRepository();
  // General HomePage provider
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    UserHomePage(),
    CartPage(),
    MyCoursesPage(),
    UserProfilePage()
  ];

  List<Widget> get screens => _widgetOptions;
  int get selectedIndex => _selectedIndex;

  set onItemClick(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  //
  Future getHomeData(context) async {
    selectedCards = [];
    _onSearch = false;
    getUserData();
    await Provider.of<FilterProvider>(context, listen: false)
        .getPreferenceList(context);
    await prefCoursesGraph(context);
    await trendingCoursesGraph(context);
    await quickCoursesGraph(context);
    getAllCourses(context);
  }

  Future refreshData(context) async {
    Future.delayed(const Duration(seconds: 75), () async {
      if (_courses.isEmpty) {
        getAllCourses(context);
      }
      if (_prefCourses.isEmpty) {
        await prefCoursesGraph(context);
      }
      if (_trendingCourses.isEmpty) {
        await trendingCoursesGraph(context);
      }
      if (_quickCourses.isEmpty) {
        await quickCoursesGraph(context);
      }
    });
  }

  // Home Screen Provider

  String _firstName = "There";

  // the list for the courses searched
  List<CoursesPref> _searchResult = [];

  // this list helps to note the selected preferences
  List<bool> selectedCards = [];

  // this list holdds the clicked trending icons
  List<bool> trendingIcons = [];

  // holds the clicked quick favorite icons
  List<bool> quickIcons = [];

  // holds the clicked top picks favorite icons
  List<bool> topIcons = [];

  List<String> courseList = [];
  Map<String, List<CoursesPref>> categories = {};
  List<CoursesPref> _courses = [];
  List<CoursesPref> _quickCourses = [];
  List<CoursesPref> _prefCourses = [];
  List<CoursesPref> _trendingCourses = [];
  bool _onSearch = false;

  bool get onSearch => _onSearch;
  String get firstName => _firstName;
  List<CoursesPref> get searchResult => _searchResult;
  List<CoursesPref> get quickCourses => _quickCourses;
  List<CoursesPref> get courses => _courses;
  List<CoursesPref> get trendingCourses => _trendingCourses;
  List<CoursesPref> get prefCourses => _prefCourses;

  void getUserData() async {
    _firstName = await UserPreferences.getUserFirstName();
    notifyListeners();
  }

  void onSearchTriggered(bool value) {
    _onSearch = value;
    notifyListeners();
  }

  void setValue(index) {
    selectedCards[index] = !selectedCards[index];
    notifyListeners();
  }

  void setTopValue(index) {
    topIcons[index] = !topIcons[index];
    notifyListeners();
  }

  void setQuickValue(index) {
    quickIcons[index] = !quickIcons[index];
    notifyListeners();
  }

  void setTrendingValue(index) {
    trendingIcons[index] = !trendingIcons[index];
    notifyListeners();
  }

  void onSearchClicked(String text) {
    _searchResult = [];
    categories.forEach((key, value) {
      if (key == text) {
        _searchResult.addAll(value);
        notifyListeners();
      } else {
        for (var element in value) {
          if (element.title!.toLowerCase().startsWith(text.toLowerCase())) {
            _searchResult.add(element);
            notifyListeners();
          }
        }
      }
    });
    notifyListeners();
  }

  Future getAllCourses(context) async {
    try {
      var response = await repo.getCompactCourse(context);
      if (response["responseCode"] == "00") {
        Map<String, dynamic> data = response['responseData'];
        _courses = [];
        print("length======>>>> ${data.length}");
        for (var value in data.keys) {
          List categories_ = data[value];
          print(("$value =====>>>> ${categories_.length}"));
          int sum = 0;
          categories_.forEach(
            (element) {
              CategoriesPref elem = CategoriesPref.fromJson(element);
              sum += elem.courses!.length;
              _courses.addAll(elem.courses!);
            },
          );
          print("$value =======>> $sum");
          notifyListeners();
        }
        notifyListeners();
        print("_courses ===>>>>> ${_courses.length}");
      } else {
        showSnack(context, response.responseCode!, response.responseMessage!);
      }
    } catch (_) {
      print(_);
    }
  }

  Future prefCoursesGraph(context) async {
    try {
      _prefCourses = [];
      Map<String, List<CoursesPref>> response =
          await repo.getPreferenceCourses(context);
      // categories.addAll(response);
      response.forEach((key, value) {
        _prefCourses.addAll(value);
        if (categories.keys.contains(key)) {
          categories[key]!.addAll(value);
        }
      });
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future quickCoursesGraph(context) async {
    try {
      _quickCourses = [];
      Map<String, List<CoursesPref>> response =
          await repo.getQuickCourses(context);
      // categories.addAll(response);
      response.forEach((key, value) {
        _quickCourses.addAll(value);
        if (categories.keys.contains(key)) {
          categories[key]!.addAll(value);
        }
      });
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future trendingCoursesGraph(context) async {
    try {
      _trendingCourses = [];
      Map<String, List<CoursesPref>> response =
          await repo.getPreferenceCourses(context);
      // categories.addAll(response);
      response.forEach((key, value) {
        _trendingCourses.addAll(value);
        if (categories.keys.contains(key)) {
          categories[key]!.addAll(value);
        } else {
          categories[key] = value;
        }
      });
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }
}
