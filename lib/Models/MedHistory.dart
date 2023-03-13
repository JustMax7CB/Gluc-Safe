class MedHistory {
  late String _medicationName;
  late int _numOfPills;
  late DateTime _date;

  MedHistory(
      String medName, int numOfPills, DateTime time) {
    _medicationName = medName;
    _numOfPills = numOfPills;
    _date = time;
  }

  get medicationName => _medicationName;
  get numOfPills => _numOfPills;
  get date => _date;
}