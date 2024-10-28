import 'package:datamine/features/about_page/about_page_bindings.dart';
import 'package:datamine/features/about_page/about_page_view.dart';
import 'package:datamine/features/decision_tree/decision_tree_bindings.dart';
import 'package:datamine/features/decision_tree/decision_tree_view.dart';
import 'package:datamine/features/home_page/home_page_view.dart';
import 'package:datamine/features/lasso/lasso_bindings.dart';
import 'package:datamine/features/lasso/lasso_view.dart';
import 'package:datamine/features/linear_regression/linear_regression_bindings.dart';
import 'package:datamine/features/linear_regression/linear_regression_training_view.dart';
import 'package:datamine/features/naive_bays/naive_bays_bindings.dart';
import 'package:datamine/features/naive_bays/naive_bays_view.dart';
import 'package:datamine/features/polynoimal_regression/polynomial_bindings.dart';
import 'package:datamine/features/polynoimal_regression/polynomial_view.dart';
import 'package:datamine/features/random_forest/random_bindings.dart';
import 'package:datamine/features/random_forest/random_view.dart';
import 'package:datamine/features/ridge/ridge_bindings.dart';
import 'package:datamine/features/ridge/ridge_view.dart';
import 'package:datamine/features/rules_page/rules_page_bindings.dart';
import 'package:datamine/features/rules_page/rules_page_view.dart';
import 'package:datamine/features/selectalgoritm/select_algo_bindings.dart';
import 'package:datamine/features/selectalgoritm/select_algo_view.dart';
import 'package:datamine/features/selection_page/selection_page_bindings.dart';
import 'package:datamine/features/selection_page/selection_page_view.dart';
import 'package:datamine/features/support_vector/support_vector_bindings.dart';
import 'package:datamine/features/support_vector/support_vector_view.dart';
import 'package:datamine/features/upload_page/upload_page_bindings.dart';
import 'package:datamine/features/upload_page/upload_page_view.dart';
import 'package:datamine/navigation/routes_constant.dart';
import 'package:get/get.dart';

import '../features/home_page/home_page_bindings.dart';

List<GetPage> getPages = [
  GetPage(
      name: RoutesConstant.home,
      page: () => HomePageView(),
      binding: HomePageBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
  GetPage(
    name: RoutesConstant.upload,
    page: () => UploadPageView(),
    binding: UploadPageBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
  GetPage(
    name: RoutesConstant.selection,
    page: () => SelectionPageView(),
    binding: SelectionPageBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
  GetPage(
    name: RoutesConstant.about,
    page: () => AboutPageView(),
    binding: AboutPageBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
  GetPage(
    name: RoutesConstant.rules,
    page: () => RulesPageView(),
    binding: RulesPageBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
  GetPage(
    name: RoutesConstant.viewAlgo,
    page: () => SelectAlgoView(),
    binding: SelectAlgoBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
  GetPage(
    name: RoutesConstant.linear,
    page: () => LinearRegressionTrainingView(),
    binding: LinearRegressionBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
  GetPage(
    name: RoutesConstant.lasso,
    page: () => LassoRegressionTrainingView(),
    binding: LassoRegressionBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
  GetPage(
    name: RoutesConstant.ridge,
    page: () => RidgeRegressionTrainingView(),
    binding: RidgeBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
  GetPage(
    name: RoutesConstant.polynomial,
    page: () => PolynomialRegressionTrainingView(),
    binding: PolynomialRegressionBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
  GetPage(
    name: RoutesConstant.decisiontree,
    page: () => DecisionTreeTrainingView(),
    binding: DecisionTreeBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
  GetPage(
    name: RoutesConstant.svm,
    page: () => SVMTrainingView(),
    binding: SVMBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
  GetPage(
    name: RoutesConstant.random,
    page: () => RandomForestTrainingView(),
    binding: RandomBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
  GetPage(
    name: RoutesConstant.naive,
    page: () => NaiveBayesTrainingView(),
    binding: NaiveBindings(),transition: Transition.fadeIn,transitionDuration:Duration(milliseconds: 5),
  ),
];
