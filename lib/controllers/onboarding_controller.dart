import 'package:flutter/material.dart';
import 'package:ads/models/onboarding_info.dart';
import 'package:get/state_manager.dart';
import 'package:get/utils.dart';

class OnboardingController extends GetxController {
  var selectedPageIndex = 0.obs;
  bool get isLastPage => selectedPageIndex.value == onboardingPages.length - 1;
  var pageController = PageController();

  forwardAction(int? page) {
    if (page != null) {
      pageController.jumpToPage(page);
    } else {
      if (isLastPage) {
        //go to home page
      } else {
        pageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
      }
    }
  }

  List<OnboardingInfo> onboardingPages = [
    OnboardingInfo(
      'assets/gif/1.gif',
      'You can use ad creation to design your ads in a step-by-step proces',
    ),
    OnboardingInfo('assets/gif/2.gif',
        'View up-to-date data on the performance of your ads and schedule reports'),
    OnboardingInfo('assets/gif/3.gif', 'Manage multiple ads at once'),
    OnboardingInfo('assets/gif/4.gif',
        'Compare campaigns and ad sets using a side-by-side view'),
  ];
}
