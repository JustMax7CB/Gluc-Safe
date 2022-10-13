class Glucose {
  final String uid;
  final DateTime timeAdded;
  final double value;

  Glucose({required this.uid, required this.timeAdded, required this.value});

  get glucValue => value;
  get glucTime => timeAdded;
}
