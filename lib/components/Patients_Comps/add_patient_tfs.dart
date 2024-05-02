import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddPatientTFs extends StatefulWidget {
  final TextEditingController controller;
  final bool onlyChars;
  final String hintText;
  final List<MaskTextInputFormatter>? maskFormatters;

  const AddPatientTFs({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onlyChars,
    this.maskFormatters,
  });

  @override
  State<AddPatientTFs> createState() => _AddPatientTFsState();
}

class _AddPatientTFsState extends State<AddPatientTFs> {
  @override
  Widget build(BuildContext context) {

    List<TextInputFormatter> formatters = widget.onlyChars
        ? [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z+-- ]"))]
        : [FilteringTextInputFormatter.deny(RegExp("[%^&*()#\$!;:'/|,]"))];

    if (widget.maskFormatters != null) {
      formatters.addAll(widget.maskFormatters!);
    }


    return TextField(
      inputFormatters: formatters,
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 12, top: 20),
        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w400),
        labelText: widget.hintText,
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        fillColor: const Color.fromARGB(246, 233, 233, 233),
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          borderSide: BorderSide(color: Color.fromARGB(255, 66, 66, 66)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 0, 0, 0),
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
