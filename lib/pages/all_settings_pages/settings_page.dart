import 'package:africa_med_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:africa_med_app/components/Dashboard_Comps/tiles.dart';
import 'package:africa_med_app/pages/all_settings_pages/account_settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //List<String> languages = ['English', 'Arabic'];
  //String? selectedLang = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: const TextStyle(color: Colors.white), //color of
        ),
        backgroundColor:
            const Color.fromARGB(159, 144, 79, 230), //app bar color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color:
              const Color.fromARGB(255, 255, 255, 255), // color of back arrow
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 105, //spacing between back arrow and text
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
                  mainText: AppLocalizations.of(context)!.account_settings,
                  subText: '',
                  width: 250,
                  height: 60,
                ),
                const SizedBox(
                  height: 25,
                ),

                SizedBox(
                    width: 250,
                    child: DropdownButton(
                      onChanged: (v) => setState(() {
                        MyApp.setLocale(context, Locale(v.toString(), ""));
                      }),
                      value: AppLocalizations.of(context)!
                          .locale
                          .toString(), // change this line with your way to get current locale to select it as default in dropdown
                      items: const [
                        DropdownMenuItem(value: "en", child: Text("English")),
                        DropdownMenuItem(value: 'ar', child: Text("Arabic")),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
