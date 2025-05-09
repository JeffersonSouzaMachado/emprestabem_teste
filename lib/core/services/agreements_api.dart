import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/const_url.dart';

class AgreementModel {
  AgreementModel({required this.agreementName});

  final String agreementName;

  factory AgreementModel.fromJson(Map<String, dynamic> json) {
    return AgreementModel(agreementName: json['valor']);
  }
}

abstract class AgreementsApi {
  Future<List<AgreementModel>> getAgreementData();
}

class AgreementsApiImpl implements AgreementsApi {
  final String serviceAgreementUrl = k_AGREEMENT_URL;

  @override
  Future<List<AgreementModel>> getAgreementData() async {
    final response = await http.get(
      Uri.parse(serviceAgreementUrl),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      List<AgreementModel> institutions =
          jsonResponse.map((item) => AgreementModel.fromJson(item)).toList();

      return institutions;
    }

    return [];
  }
}
