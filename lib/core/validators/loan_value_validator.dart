class LoanValueValidator {
  validate({String? value}) {
    if (value == null || value.isEmpty) {
      return 'O valor é obrigatório.';
    }
    return null;
  }
}
