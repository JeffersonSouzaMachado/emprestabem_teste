import 'dart:convert';
import 'dart:developer';

import 'package:emprestabem/core/constants/const_url.dart';
import 'package:http/http.dart' as http;

class SimulateModel {
  SimulateModel({
    required this.loanValue,
    required this.institution,
    required this.agreement,
    required this.installment,
  });

  final double loanValue;
  final List<String> institution;
  final List<String> agreement;
  final int installment;

  Map<String, dynamic> toJson() {
    return {
      'valor_emprestimo': loanValue,
      'instituicoes': institution,
      'convenios': agreement,
      'parcelas': installment,
    };
  }
}

class SimulateResult {
  final double taxa;
  final int parcelas;
  final double valorParcela;
  final String convenio;

  SimulateResult({
    required this.taxa,
    required this.parcelas,
    required this.valorParcela,
    required this.convenio,
  });

  factory SimulateResult.fromJson(Map<String, dynamic> json) {
    return SimulateResult(
      taxa: (json['taxa'] as num?)?.toDouble() ?? 0.0,
      parcelas: json['parcelas'] ?? 0,
      valorParcela: (json['valor_parcela'] as num?)?.toDouble() ?? 0.0,
      convenio: json['convenio'] ?? '',
    );
  }
}

class SimulateGroupedResult {
  final Map<String, List<SimulateResult>> data;

  SimulateGroupedResult({required this.data});

  factory SimulateGroupedResult.fromJson(dynamic json) {
    final map = <String, List<SimulateResult>>{};

    //Neste trecho eu separo por tipo de retorno, já que pode vir da uma lista ou um map

    if (json is List) {
      for (final item in json) {
        final institution = item['instituicao'] ?? 'Desconhecida';
        final result = SimulateResult.fromJson(item);
        map.putIfAbsent(institution, () => []).add(result);
      }
    } else if (json is Map<String, dynamic>) {
      json.forEach((key, value) {
        if (value is List) {
          final list =
              value
                  .map(
                    (e) => SimulateResult.fromJson(e as Map<String, dynamic>),
                  )
                  .toList();
          map[key] = list;
        }
      });
    } else {
      throw Exception('Formato de resposta da simulação inválido');
    }

    return SimulateGroupedResult(data: map);
  }
}

abstract class SimulateApi {
  Future<SimulateGroupedResult> simulate(SimulateModel simulation);
}

class SimulateApiImpl implements SimulateApi {
  final String serviceSimulateUrl = k_SIMULATE_URL;

  @override
  Future<SimulateGroupedResult> simulate(SimulateModel simulation) async {
    final response = await http.post(
      Uri.parse(serviceSimulateUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(simulation.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return SimulateGroupedResult.fromJson(jsonResponse);
    } else {
      throw Exception('Erro na simulação: ${response.statusCode}');
    }
  }
}
