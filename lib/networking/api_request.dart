import 'dart:convert';
import 'dart:io';

import 'package:adss_machine_test_e_commerce/models/restaurant_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../constants/api_consts.dart';

class ApiManagement {
  static Future<List<RestaurantData>?> getDishes(BuildContext context) async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/mock_restaurant_data.json');

       if (jsonString.isNotEmpty) {
        List<RestaurantData> model = restaurantDataFromJson(jsonString);
         return model;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to retrieve data. Please try again later.'),
            ),
          );
        }
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Network connection error. Please check your internet connection and try again.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('An unexpected error occurred. Please try again later.'),
        ),
      );
    }
    return null;
  }
}
