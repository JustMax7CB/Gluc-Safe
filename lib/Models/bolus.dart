class Bolus {
  DateTime? _date;
  bool? _isMealBolus;
  bool? _isCorrectionBolus;
  double? _carbohydrateIntake;
  double? _carbohydrateRatio;
  double? _bloodGlucose;
  double? _targetGlucose;
  double? _correctionFactor;
  double? _bolusDose;

  Bolus(
      DateTime date,
      bool isMealBolus,
      bool isCorrectionBolus,
      double carbohydrateIntake,
      double carbohydrateRatio,
      double bloodGlucose,
      double targetGlucose,
      double correctionFactor,
      double bolusDose) {
    _date = date;
    _isMealBolus = isMealBolus;
    _isCorrectionBolus = isCorrectionBolus;
    _carbohydrateIntake = carbohydrateIntake;
    _carbohydrateRatio = carbohydrateRatio;
    _bloodGlucose = bloodGlucose;
    _targetGlucose = targetGlucose;
    _correctionFactor = correctionFactor;
    _bolusDose = bolusDose;
  }

  get date => _date;
  get isMealBolus => _isMealBolus;
  get isCorrectionBolus => _isCorrectionBolus;
  get carbohydrateIntake => _carbohydrateIntake;
  get carbohydrateRatio => _carbohydrateRatio;
  get bloodGlucose => _bloodGlucose;
  get targetGlucose => _targetGlucose;
  get correctionFactor => _correctionFactor;
  get bolusDose => _bolusDose;
}
