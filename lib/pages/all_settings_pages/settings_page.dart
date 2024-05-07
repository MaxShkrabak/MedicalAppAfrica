import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:africa_med_app/components/Dashboard_Comps/tiles.dart';
import 'package:africa_med_app/pages/all_settings_pages/account_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //List<String> languages = ['English', 'Russian', 'Ugandan'];
  //String? selectedLang = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white), //color of
        ),
        backgroundColor:
            const Color.fromARGB(160, 165, 96, 255), //app bar color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color:
              const Color.fromARGB(255, 255, 255, 255), // color of back arrow
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 100, //spacing between back arrow and text
      ),
      body: Scaffold(
        backgroundColor:
            const Color.fromARGB(246, 244, 236, 255), //background color
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 7),
                // Account Settings button
                Tiles(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: ((context) => const AccountSettings()),
                      ),
                    );
                  },
                  mainText: 'Account Settings',
                  subText: '',
                  width: 250,
                  height: 60,
                ),
                const SizedBox(
                  height: 25,
                ),
                // Language button
                Tiles(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: ((context) => const AccountSettings()),
                      ),
                    );
                  },
                  mainText: 'Language',
                  width: 250,
                  height: 60,
                  subText: '',
                ),

                const SizedBox(height: 15),
                /* SizedBox(
                  width: 250,
                  child: DropdownButton<String>(
                    value: selectedLang,
                    items: languages
                        .map((item) => DropdownMenuItem<String>(
                            value: item, child: Text(item)))
                        .toList(),
                    onChanged: (item) => setState(() => selectedLang = item),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
