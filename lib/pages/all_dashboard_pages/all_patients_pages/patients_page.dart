import 'package:flutter/material.dart';

class PatientList extends StatefulWidget {
  const PatientList({super.key});

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _patients = [];
  final List<String> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPatientPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchTextChanged,
              decoration: InputDecoration(
                labelText: 'Search Patients',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchTextChanged('');
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_searchResults[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchTextChanged(String value) {
    _searchResults.clear();
    if (value.isEmpty) {
      setState(() {});
      return;
    }

    for (var patient in _patients) {
      if (patient.toLowerCase().contains(value.toLowerCase())) {
        _searchResults.add(patient);
      }
    }

    setState(() {});
  }
}

class AddPatientPage extends StatelessWidget {
  const AddPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'First Name:',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter first name',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Middle Name:',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter middle name',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Last Name:',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter last name',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Date of Birth (YYYY/MM/DD):',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter date of birth',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Blood Group:',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter blood group',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'RH Factor:',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter RH factor',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Marital Status:',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter marital status',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Preferred Language:',
                style: TextStyle(fontSize: 16),
              ),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Enter preferred language',
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondPage()),
                    );
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Information'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Home Phone:',
              style: TextStyle(fontSize: 16),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter home phone',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Phone:',
              style: TextStyle(fontSize: 16),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter phone number',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Email Address:',
              style: TextStyle(fontSize: 16),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter email address',
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Emergency Contact',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'First Name:',
              style: TextStyle(fontSize: 16),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter first name',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Last Name:',
              style: TextStyle(fontSize: 16),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter last name',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Relationship:',
              style: TextStyle(fontSize: 16),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter relationship',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Phone Number:',
              style: TextStyle(fontSize: 16),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter phone number',
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ThirdPage()),
                    );
                  },
                  child: const Text('Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical History'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Known Medical Illnesses:',
              style: TextStyle(fontSize: 16),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter known medical illnesses',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Previous Medical Illnesses:',
              style: TextStyle(fontSize: 16),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter previous medical illnesses',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Allergies:',
              style: TextStyle(fontSize: 16),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter allergies',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Current Medications:',
              style: TextStyle(fontSize: 16),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter current medications',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Past Medications:',
              style: TextStyle(fontSize: 16),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Enter past medications',
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Finish'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
