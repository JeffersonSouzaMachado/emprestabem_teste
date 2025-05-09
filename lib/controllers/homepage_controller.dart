import 'package:flutter/material.dart';

import '../core/services/agreements_api.dart';
import '../core/services/institution_api.dart';
import '../core/services/simulate_api.dart';
import '../core/validators/loan_value_validator.dart';

class HomepageController {
  TextEditingController valueController = TextEditingController();
  final InstitutionApi _institutionApi = InstitutionApiImpl();
  final AgreementsApi _agreementsApi = AgreementsApiImpl();
  final SimulateApi _simulateApi = SimulateApiImpl();
  List<InstitutionModel> institutionList = [];
  List<AgreementModel> agreementList = [];

  Future<void> fetchData({
    required Function(List<InstitutionModel>, List<AgreementModel>) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final response = await Future.wait([
        _institutionApi.getInstitutionData(),
        _agreementsApi.getAgreementData(),
      ]);

      onSuccess(
        response[0] as List<InstitutionModel>,
        response[1] as List<AgreementModel>,
      );
    } catch (e) {
      onError('Erro ao obter dados da API');
    }
  }

  Future<SimulateGroupedResult> simulate({
    required BuildContext context,
    required String? installmentSelected,
    required InstitutionModel? institutionSelected,
    required AgreementModel? agreementSelected,
  }) async {
    final validatorResult = LoanValueValidator().validate(
      value: valueController.text,
    );
    if (validatorResult != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(validatorResult)),
      );
      return Future.error('Campos vazios, sem validação');
    }

    final cleanedValue =
        valueController.text
            .replaceAll('R\$', '')
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .trim();

    final simulation = SimulateModel(
      loanValue: double.tryParse(cleanedValue) ?? 0.0,
      institution:
          institutionSelected != null
              ? [institutionSelected.institutionName]
              : [],
      agreement:
          agreementSelected != null ? [agreementSelected.agreementName] : [],
      installment:
          installmentSelected != null ? int.parse(installmentSelected) : 0,
    );

    try {
      return await _simulateApi.simulate(simulation);
    } catch (e) {
      print('ERROR $e');
      throw Exception('Erro na simulação');
    }
  }
}
