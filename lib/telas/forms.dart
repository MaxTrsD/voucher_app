String getMonthName(String dateString) {
  List<String> parts = dateString.split('/');

  if (parts.length != 3) {
    return 'Formato inválido';
  }

  int month = int.tryParse(parts[1]) ?? 0;
  switch (month) {
    case 1:
      return 'Janeiro';
    case 2:
      return 'Fevereiro';
    case 3:
      return 'Março';
    case 4:
      return 'Abril';
    case 5:
      return 'Maio';
    case 6:
      return 'Junho';
    case 7:
      return 'Julho';
    case 8:
      return 'Agosto';
    case 9:
      return 'Setembro';
    case 10:
      return 'Outubro';
    case 11:
      return 'Novembro';
    case 12:
      return 'Dezembro';
    default:
      return 'Mês inválido';
  }
}

void main() {
  String date = '12/05/2023'; // Exemplo de entrada do usuário (dia/mês/ano)
  String monthName = getMonthName(date);
  print(monthName); // Saída: Maio
}
