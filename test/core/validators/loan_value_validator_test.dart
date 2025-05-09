import 'package:emprestabem/core/validators/loan_value_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LoanValueValidator loanValueValidator;

  setUp(() {
    loanValueValidator = LoanValueValidator();
  });

  group('Validação do valor do Empréstimo', () {
    test('Retorna uma mensagem de erro caso valor seja nulo', () {
      final result = loanValueValidator.validate();
      expect(result, equals('O valor é obrigatório.'));
    });
  });
}
