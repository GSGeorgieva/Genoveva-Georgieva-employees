import 'entity/entity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class EmployeesPairs {
  List? employeeIds;
  int? projectId;
  int? daysTogether;

  void increment(int value) => daysTogether = daysTogether! + value;
}

List<EmployeesPairs>? parseResult(PlatformFile? selectedCsvFile) {
  List<Employee> employees = [];
  List<EmployeesPairs> result = [];
  try {
    String s = String.fromCharCodes(selectedCsvFile!.bytes as Iterable<int>);
    var outputAsUint8List = Uint8List.fromList(s.codeUnits);
    final csvFileContentList = utf8.decode(outputAsUint8List).split('\n');
    final csvList = csvFileContentList.toSet().toList();
    for (var csvRow in csvList) {
      if (csvRow.trim().isNotEmpty) {
        if (csvRow.split(',').contains('EmpID')) continue;
        employees.add(Employee.fromList(csvRow.split(',')));
      }
    }
    for (int c = 0; c < employees.length; c++) {
      for (int n = c + 1; n < employees.length; n++) {
        final current = employees[c];
        final next = employees[n];
        if (current.employeeId == next.employeeId) continue;
        //If projects are different
        if (current.projectId != next.projectId) continue;
        //If current empl. worked on the project before the next one
        if (current.dateTo!.isBefore(next.dateFrom!)) continue;
        //If current empl. worked on the project after the next one
        if (current.dateFrom!.isAfter(next.dateTo!)) continue;

        final currentProject = EmployeesPairs()
          ..employeeIds = [current.employeeId, next.employeeId]
          ..projectId = current.projectId
          ..daysTogether = 0;

        //if Current Employee started on the project after nextEmployee
        if (current.dateFrom!.isAfter(next.dateFrom!)) {
          //ended before second or the same as him
          if (current.dateTo!.isBefore(next.dateTo!) ||
              current.dateTo!.isAtSameMomentAs(next.dateTo!)) {
            currentProject.increment(
                current.dateTo!.difference(current.dateFrom!).inDays);
          }
          //ended after second
          else {
            currentProject
                .increment(next.dateTo!.difference(current.dateFrom!).inDays);
          }
        }
        //if Current Employee started on the project before nextEmployee
        else if (current.dateFrom!.isBefore(next.dateFrom!) ||
            current.dateFrom!.isAtSameMomentAs(next.dateFrom!)) {
          if (current.dateTo!.isAfter(next.dateTo!) ||
              current.dateTo!.isAtSameMomentAs(next.dateTo!) ||
              current.dateFrom!.isAtSameMomentAs(next.dateFrom!)) {
            currentProject
                .increment(next.dateTo!.difference(next.dateFrom!).inDays);
          } else {
            currentProject
                .increment(current.dateTo!.difference(next.dateFrom!).inDays);
          }
        }
        result.add(currentProject);
      }
    }
  } on Exception catch (e) {
    print('EXEPTION $e');
    return null;
  }

  result.sort((c, n) => n.daysTogether!.compareTo(c.daysTogether!));
  return result;
}
