import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'parse_result.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<EmployeesPairs>? data;
  List<PlatformFile>? _paths;

  Future _openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        withData: true,
        allowedExtensions: ["csv"],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation ${e.toString()}");
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    if (_paths == null) return;
    await _openFile();
  }

  Future _openFile() async {
    setState(() {
      data = parseResult(_paths!.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              ListView(
                  shrinkWrap: true,
                  children: List.generate(data?.length ?? 0, (index) {
                    final exp = data?[index];
                    return AboutListTile(
                        child: EmployeesRender(exp, index == 0));
                  }))
            ])),
        floatingActionButton: FloatingActionButton(
            onPressed: _openFileExplorer,
            tooltip: 'Upload CSV File',
            child: const Icon(Icons.table_view)));
  }
}

class EmployeesRender extends StatelessWidget {
  final EmployeesPairs? ep;
  final bool? isFirst;

  const EmployeesRender(this.ep, this.isFirst, {super.key});

  @override
  Widget build(BuildContext context) {
    if (ep != null) {
      return Column(
        children: [
          (isFirst != null && isFirst!) ? _defaultRow : const Divider(),
          Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        height: 50,
                        alignment: Alignment.center,
                        child: Text('${ep!.employeeIds![0]}')),
                    Container(
                        alignment: Alignment.center,
                        child: Text('${ep!.employeeIds![1]}')),
                    Container(
                        alignment: Alignment.center,
                        child: Text('${ep!.projectId!}')),
                    Container(
                        alignment: Alignment.center,
                        child: Text('${ep!.daysTogether!}'))
                  ]))
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Row get _defaultRow => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                height: 50,
                alignment: Alignment.center,
                child: const Text('Employee ID #1',
                    style: TextStyle(fontSize: 10))),
            Container(
                alignment: Alignment.center,
                child: const Text('Employee ID #2',
                    style: TextStyle(fontSize: 10))),
            Container(
                alignment: Alignment.center,
                child:
                    const Text('Project ID', style: TextStyle(fontSize: 10))),
            Container(
                alignment: Alignment.center,
                child:
                    const Text('Days worked', style: TextStyle(fontSize: 10)))
          ]);
}
