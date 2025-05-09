import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/const_url.dart';

class InstitutionModel {
  InstitutionModel({required this.institutionName});

  final String institutionName;

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(institutionName: json['valor']);
  }
}

abstract class InstitutionApi {
  Future<List<InstitutionModel>> getInstitutionData();
}

class InstitutionApiImpl implements InstitutionApi {
  final String serviceInstitutionUrl = k_INSTITUTION_URL ;


  @override
  Future<List<InstitutionModel>> getInstitutionData() async {
    final response = await http.get(
      Uri.parse(serviceInstitutionUrl),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      List<InstitutionModel> institutions =
          jsonResponse.map((item) => InstitutionModel.fromJson(item)).toList();

      return institutions;
    }

    return [];
  }
}
