class Weight {
  late DateTime _date;
  late int _weight;

  Weight(DateTime date, int weight) {
    _date = date;
    _weight = weight;
  }

  get date => _date;
  get weight => _weight;
}
