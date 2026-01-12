class DateHijriPrayer {
  HijriDate? hijriDate;
  DateTime? gregorianDate;

  DateHijriPrayer({this.hijriDate, this.gregorianDate});

  DateHijriPrayer copyWith({HijriDate? hijriDate, DateTime? gregorianDate}) =>
      DateHijriPrayer(
        hijriDate: hijriDate ?? this.hijriDate,
        gregorianDate: gregorianDate ?? this.gregorianDate,
      );

  factory DateHijriPrayer.fromJson(Map<String, dynamic> json) =>
      DateHijriPrayer(
        hijriDate:
            json['hijri_date'] == null
                ? null
                : HijriDate.fromJson(json['hijri_date']),
        gregorianDate:
            json['gregorian_date'] == null
                ? null
                : DateTime.parse(json['gregorian_date']),
      );

  Map<String, dynamic> toJson() => {
    'hijri_date': hijriDate?.toJson(),
    'gregorian_date':
        "${gregorianDate!.year.toString().padLeft(4, '0')}-${gregorianDate!.month.toString().padLeft(2, '0')}-${gregorianDate!.day.toString().padLeft(2, '0')}",
  };
}

class HijriDate {
  int? year;
  int? month;
  int? day;
  String? monthName;

  HijriDate({this.year, this.month, this.day, this.monthName});

  HijriDate copyWith({int? year, int? month, int? day, String? monthName}) =>
      HijriDate(
        year: year ?? this.year,
        month: month ?? this.month,
        day: day ?? this.day,
        monthName: monthName ?? this.monthName,
      );

  factory HijriDate.fromJson(Map<String, dynamic> json) => HijriDate(
    year: json['year'],
    month: json['month'],
    day: json['day'],
    monthName: json['month_name'],
  );

  Map<String, dynamic> toJson() => {
    'year': year,
    'month': month,
    'day': day,
    'month_name': monthName,
  };
}
