import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';

void main() {
  runApp(const MaterialApp(
    title: "File Handling",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  String _displayText = '';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  Future<File> _getFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  Future<void> writeToFile(String filename, List<String> data) async {
    try {
      final file = await _getFile(filename);
      await file.writeAsString(data.join('\n'));
    } catch (e) {
      print("Error writing to file: $e");
    }
  }

  Future<List<String>> readFromFile(String filename) async {
    try {
      final file = await _getFile(filename);
      final contents = await file.readAsString();
      return contents.split('\n');
    } catch (e) {
      print("Error reading from file: $e");
      return [];
    }
  }

  Future<void> processFileData(String inputFilename, String outputFilename) async {
    try {
      final inputData = await readFromFile(inputFilename);
      final reversedData = inputData.map((line) => line.split('').reversed.join()).toList();
      await writeToFile(outputFilename, reversedData);
    } catch (e) {
      print("Error processing file data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'S A V E   D A T A',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.yellow,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'W E L C O M E',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your message',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.yellow,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  await writeToFile('input.txt', [_controller.text]);
                  setState(() {
                    _displayText = 'Data saved successfully!';
                  });
                }
              },
              child: const Text('Write Data'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.yellow,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () async {
                    final data = await readFromFile('input.txt');
                    setState(() {
                      _displayText = data.join('\n');
                    });
                  },
                  child: const Text('Read Straight'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.yellow,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () async {
                    await processFileData('input.txt', 'output.txt');
                    final data = await readFromFile('output.txt');
                    setState(() {
                      _displayText = data.join('\n');
                    });
                  },
                  child: const Text('Read Reverse'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _displayText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.yellow,
    );
  }
}
