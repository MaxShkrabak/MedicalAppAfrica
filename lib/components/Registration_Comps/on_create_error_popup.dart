import "package:flutter/material.dart";

void onCreateErrorPopUp(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          insetPadding:
              const EdgeInsets.symmetric(vertical: 200.0, horizontal: 80.0),
          backgroundColor: const Color.fromARGB(255, 192, 191, 191),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Text(
                  text,
                  style: const TextStyle(color: Colors.black, fontSize: 14.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15.0),
                const Divider(
                  color: Colors.black,
                  height: 12,
                  thickness: 1,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 14, 101, 182)),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
    },
  );
}
