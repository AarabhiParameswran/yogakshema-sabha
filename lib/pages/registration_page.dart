import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:yoga_kshema_sabha/pages/individual_use_screen.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? _selectedUpasabha;
  List<String> _upasabhas = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUpasabhas();
  }

  Future<void> _fetchUpasabhas() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse('https://your-backend-url.com/upasabha-data'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _upasabhas = List<String>.from(data['upasabhas']);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _register() {
    String? upasabha = _selectedUpasabha;

    // Save the user data to a database or perform necessary actions
    // You can use a backend service or local storage for data management

    // After registration, you can navigate to the home screen or perform other actions
    Navigator.pop(context); // Go back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Registration',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.orange[600],
        toolbarHeight: 80.0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isLoading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                value: _selectedUpasabha,
                hint: const Text(
                  'Select Upasabha',
                  style: TextStyle(color: Colors.black),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedUpasabha = newValue;
                  });
                },
                items: _upasabhas.map((String upasabha) {
                  return DropdownMenuItem<String>(
                    value: upasabha,
                    child: Text(upasabha),
                  );
                }).toList(),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.8),
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.orange[100],
                ),
                dropdownColor: Colors.orange[100],
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange[600],
                    minimumSize: const Size.fromHeight(60),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const IndividualUserScreen()),
                    );
                  },
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
