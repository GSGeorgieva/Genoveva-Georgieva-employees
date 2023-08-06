part of entity.dart;

@JsonSerializable()
class Employee {
  int? employeeId;
  int? projectId;
  DateTime? dateFrom;
  DateTime? dateTo;

  Employee({this.employeeId, this.projectId, this.dateFrom, this.dateTo});

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);

  Employee.fromList(List items)
      : this(
            employeeId: items[0].trim() is String
                ? int.parse(items[0].trim())
                : items[0].trim(),
            projectId: items[1].trim() is String
                ? int.parse(items[1].trim())
                : items[1].trim(),
            dateFrom: parseDateCustom(items[2].trim()),
            dateTo: parseDateCustom(items[3].trim()) ?? DateTime.now());
}
