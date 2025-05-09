import 'package:emprestabem/core/constants/colors.dart';
import 'package:emprestabem/core/services/agreements_api.dart';
import 'package:emprestabem/core/services/institution_api.dart';
import 'package:emprestabem/core/services/simulate_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../controllers/homepage_controller.dart';
import '../../core/constants/installment_options.dart';
import '../../widgets/input/custom_dropdown.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final controller = HomepageController();
  String? installmentSelected;
  InstitutionModel? institutionSelected;
  AgreementModel? agreementSelected;
  List<InstitutionModel> institutionList = [];
  List<AgreementModel> agreementList = [];
  SimulateGroupedResult? simulateResults;

  @override
  void initState() {
    super.initState();
    controller.fetchData(
      onSuccess: (institutions, agreements) {
        setState(() {
          institutionList = institutions;
          agreementList = agreements;
        });
      },
      onError: (message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(message)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Simulador App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: EmprestaColors.blueEmpresta,
          ),
        ),
        actions: [
          IconButton(
            onPressed: resetAll,
            icon: Icon(Icons.restart_alt, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: controller.valueController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      CurrencyInputFormatter(
                        leadingSymbol: 'R\$',
                        useSymbolPadding: true,
                        thousandSeparator: ThousandSeparator.Period,
                      ),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      label: Text('Valor do Empréstimo *'),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange, width: 2),
                      ),
                    ),
                  ),

                  CustomDropdown(
                    label: 'Quantidade de Parcelas',
                    selectedValue: installmentSelected,
                    options: installmentList,
                    getLabel: (title) => title,
                    onChanged:
                        (value) => setState(() => installmentSelected = value),
                  ),

                  CustomDropdown<InstitutionModel>(
                    label: 'Instituição',
                    selectedValue: institutionSelected,
                    options: institutionList,
                    getLabel: (i) => i.institutionName,
                    onChanged:
                        (value) => setState(() => institutionSelected = value),
                  ),
                  CustomDropdown<AgreementModel>(
                    label: 'Convênios',
                    selectedValue: agreementSelected,
                    options: agreementList,
                    getLabel: (i) => i.agreementName,
                    onChanged:
                        (value) => setState(() => agreementSelected = value),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ElevatedButton(
                      onPressed: simulate,
                      child: Text(
                        'Simular',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                        simulateResults == null
                            ? SizedBox()
                            : simulateResults!.data.isEmpty
                            ? Center(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Tente outras opções e encontre a melhor!',
                                  style: TextStyle(
                                    color: EmprestaColors.blueEmpresta,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            )
                            : ListView(
                              children:
                                  simulateResults!.data.entries.expand((entry) {
                                    final institution = entry.key;
                                    final results = entry.value;
                                    return [
                                      ...results.map(
                                        (result) => Card(
                                          margin: EdgeInsets.symmetric(
                                            vertical: 6,
                                          ),
                                          child: ListTile(
                                            leading: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                              child: Text(
                                                institution,
                                                style: TextStyle(
                                                  color:
                                                      EmprestaColors
                                                          .blueEmpresta,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            title: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('Valor solicitado: '),
                                                    Text(
                                                      controller
                                                          .valueController
                                                          .text,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Parcelas: '),
                                                    Text(
                                                      '${result.parcelas} x ${'R\$ ${result.valorParcela.toStringAsFixed(2)}'}',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            subtitle: Text(
                                              'Taxa: ${result.taxa.toStringAsFixed(2)}%',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ];
                                  }).toList(),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void resetAll() {
    setState(() {
      installmentSelected = null;
      institutionSelected = null;
      agreementSelected = null;
      simulateResults = null;
      controller.valueController.text = '';
    });
  }

  void simulate() {
    FocusScope.of(context).unfocus();

    if (simulateResults != null) {
      setState(() {
        simulateResults = null;
      });
    }
    controller
        .simulate(
          context: context,
          installmentSelected: installmentSelected,
          institutionSelected: institutionSelected,
          agreementSelected: agreementSelected,
        )
        .then((simulateResult) {
          setState(() {
            simulateResults = simulateResult;
          });
        });
  }
}
