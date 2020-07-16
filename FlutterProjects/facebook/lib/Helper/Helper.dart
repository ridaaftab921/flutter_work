
class Helper {

  Helper._privateConstructor();

  static final Helper instance = Helper._privateConstructor();


  Future<DateTime> concertToDateTime(String date) async {
    return DateTime.parse(date);
  }

  Future<bool> isValid(DateTime expiryDate) async {
    DateTime now = DateTime.now();
    return now.isBefore(expiryDate);
  }

  int toFahrenheit(double celsius) => ((celsius * 9 / 5) + 32).round();

}