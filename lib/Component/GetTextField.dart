import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maintenance/Component/CompanyDetails.dart';
import 'package:maintenance/Component/CustomColor.dart';
import 'package:maintenance/Component/DatePopup.dart';
import 'package:maintenance/Component/GetFormattedDate.dart';
import 'package:maintenance/Component/SnackbarComponent.dart';

Widget getTextField(
    {required TextEditingController controller,
    String? labelText,
    String suffixText = "",
    Widget? suffixIcon,
    Widget? prefixIcon,
    BuildContext? context,
    TextAlign? textAlign,
    FocusNode? focusNode,
      Color? iconColor,
    Function? onLookupPressed,
    bool enableLookup = false,
    TextDirection? textDirection,
    Color? fillColor,
    Key? key,
    AutovalidateMode? autoValidateMode,
    Color cursorColor = Colors.black,
    TextStyle? style,
    TextInputAction? textInputAction,
    String? Function(String? value)? validator,
    Function(String value)? onFieldSubmitted,
    Function(String value)? onChanged,
    bool obscureText = false,
    bool autofocus = false,
    bool readOnly = false,
    bool enabled = true,
    bool enableInteractiveSelection = true,
    bool enableSuggestions = false,
    int? maxLines,
    int? maxLength,
    Function? onTap,
    IconButton? iconButton,
    List<TextInputFormatter>? inputFormatters,
    double? height = 43,
    TextInputType? keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 6.0,
      left: 8,
      right: 8,
    ),
    child: Container(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              onChanged: (val) {
                if (onChanged != null) {
                  onChanged(val);
                }
              },
              inputFormatters: inputFormatters,
              decoration: new InputDecoration(
                labelStyle: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500),
                filled: true,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                labelText: labelText,
                contentPadding:
                    const EdgeInsets.only(bottom: 2.0, top: 2, left: 12),

                //prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                fillColor: Colors.white,
                disabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: barColor, width: 1),
                ),
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: barColor, width: 1),
                ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: barColor, width: 1),
                ),
                //fillColor: Colors.green
              ),
              maxLines: maxLines,
              keyboardType: keyboardType,
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          enableLookup
              ? iconButton == null
                  ? IconButton(
                      icon: Icon(
                        Icons.search,
                        color: iconColor??barColor,
                      ),
                      onPressed: onLookupPressed != null
                          ? onLookupPressed as Function()
                          : null,
                    )
                  : iconButton
              : iconButton == null
                  ? IconButton(
                      icon: Icon(
                        Icons.search,
                        color:iconColor?? Colors.white,
                      ),
                      onPressed: null,
                    )
                  : iconButton
        ],
      ),
    ),
  );
}

Widget getTextFieldWithoutLookup(
    {required TextEditingController controller,
    String? labelText,
    String suffixText = "",
    Widget? suffixIcon,
    Widget? prefixIcon,
    BuildContext? context,
    TextAlign? textAlign,
    FocusNode? focusNode,
    Function? onLookupPressed,
    bool enableLookup = false,
    TextDirection? textDirection,
    Color? fillColor,
    Key? key,
    AutovalidateMode? autoValidateMode,
    Color cursorColor = Colors.black,
    TextStyle? style,
    TextInputAction? textInputAction,
    String? Function(String? value)? validator,
    Function(String value)? onFieldSubmitted,
    Function(String value)? onChanged,
    Function? onEditingComplete,
    bool obscureText = false,
    bool autofocus = false,
    bool readOnly = false,
    bool enabled = true,
    bool enableInteractiveSelection = true,
    bool enableSuggestions = false,
    int? maxLines,
    int? maxLength,
    Function? onTap,
    IconButton? iconButton,
    List<TextInputFormatter>? inputFormatters,
    double? height = 43,
    double? fontSize = 14,
    TextInputType? keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 6.0,
      left: 8,
      right: 8,
    ),
    child: Container(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              onChanged: (val) {
                if (onChanged != null) {
                  onChanged(val);
                }
              },
              onEditingComplete: () {
                // Your event handling code here
                print('Editing complete');
                if(onEditingComplete!=null)
                  {
                    onEditingComplete();

                  }


              },
              obscureText: obscureText,
              inputFormatters: inputFormatters,
              decoration: new InputDecoration(
                labelStyle: GoogleFonts.poppins(
                    fontSize: fontSize, fontWeight: FontWeight.w500),
                filled: true,

                labelText: labelText,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,

                contentPadding:
                    const EdgeInsets.only(bottom: 2.0, top: 2, left: 12),

                //prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                fillColor: Colors.white,
                disabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: barColor, width: 1),
                ),
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: barColor, width: 1),
                ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: barColor, width: 1),
                ),
                //fillColor: Colors.green
              ),
              maxLines: maxLines,
              keyboardType: keyboardType,
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget getDateTextField(
    {required TextEditingController controller,
    required TextEditingController localCurrController,
    String? labelText,
    String suffixText = "",
    Widget? suffixIcon,
    Widget? prefixIcon,
    BuildContext? context,
    TextAlign? textAlign,
    FocusNode? focusNode,
      Color? iconColor,
    TextDirection? textDirection,
    Key? key,
    AutovalidateMode? autoValidateMode,
    Color cursorColor = Colors.black,
    TextStyle? style,
    TextInputAction? textInputAction,
    String? Function(String? value)? validator,
    Function(String value)? onFieldSubmitted,
    Function(String value)? onChanged,
    bool obscureText = false,
    bool autofocus = false,
    bool enabled = true,
    bool enableInteractiveSelection = true,
    bool enableSuggestions = false,
    Function? onLookupPressed,
    bool enableLookup = false,
    int? maxLines,
    Function? onTap,
    int? maxLength,
    IconButton? iconButton,
    List<TextInputFormatter>? inputFormatters,
    double? height = 43,
    double? fontSize = 14,
    TextInputType? keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 6.0,
      left: 8,
      right: 8,
    ),
    child: Container(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: TextFormField(
                controller: controller,
                onChanged: (val) {
                  if (onChanged != null) {
                    onChanged(val);
                  }
                },
                inputFormatters: inputFormatters,
                decoration: new InputDecoration(
                  labelStyle: GoogleFonts.poppins(
                      fontSize: fontSize, fontWeight: FontWeight.w500),
                  filled: true,
                  labelText: labelText,
                  suffixIcon: suffixIcon,
                  prefixIcon: prefixIcon,
                  contentPadding:
                      const EdgeInsets.only(bottom: 2.0, top: 2, left: 12),

                  //prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                  fillColor: Color(0XFFF3ECE7),
                  disabledBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(color: barColor, width: 1),
                  ),
                  hoverColor: Colors.red,
                  focusedBorder: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(color: barColor, width: 1),
                  ),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(color: barColor, width: 1),
                  ),
                  //fillColor: Colors.green
                ),
                maxLines: maxLines,
                readOnly: true,
                onTap: onTap != null
                    ? onTap as Function()
                    : () async {
                        await getDatePopup(
                            initialDate: controller.text.isNotEmpty
                                ? getDateFromString(controller.text)
                                : null,
                            onDatePicked: (String pickedDate) async {
                              localCurrController.text = await getLocalDate(
                                  getDateFromString(pickedDate));
                              print(pickedDate);

                              if (onChanged != null) {
                                onChanged(pickedDate);
                              }
                            });
                      },
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          if (CompanyDetails.ocinModel?.IsLocalDate == true)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: TextFormField(
                  controller: localCurrController,
                  onChanged: (val) {
                    if (onChanged != null) {
                      onChanged(val);
                    }
                  },
                  decoration: new InputDecoration(
                    labelStyle: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w500),
                    filled: true,
                    labelText: "Local $labelText",
                    suffixIcon: suffixIcon,
                    prefixIcon: prefixIcon,
                    contentPadding:
                        const EdgeInsets.only(bottom: 2.0, top: 2, left: 12),

                    //prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                    fillColor: Color(0XFFF3ECE7),
                    disabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: barColor, width: 1),
                    ),
                    hoverColor: Colors.red,
                    focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: barColor, width: 1),
                    ),
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: barColor, width: 1),
                    ),
                    //fillColor: Colors.green
                  ),
                  maxLines: maxLines,
                  readOnly: true,
                  onTap: onTap != null
                      ? onTap as Function()
                      : () {
                          getErrorSnackBar('Uneditable');
                        },
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          enableLookup
              ? iconButton == null
                  ? IconButton(
                      icon: Icon(
                        Icons.search,
                        color: iconColor??barColor,
                      ),
                      onPressed: onLookupPressed != null
                          ? onLookupPressed as Function()
                          : null,
                    )
                  : iconButton
              : iconButton == null
                  ? IconButton(
                      icon: Icon(
                        Icons.search,
                        color: iconColor??Colors.white,
                      ),
                      onPressed: null,
                    )
                  : iconButton
        ],
      ),
    ),
  );
}

Widget getDisabledTextField(
    {required TextEditingController controller,
    String? labelText,
    String suffixText = "",
    Widget? suffixIcon,
    Widget? prefixIcon,
    BuildContext? context,
    TextAlign? textAlign,
    FocusNode? focusNode,
    TextDirection? textDirection,
    Key? key,
    AutovalidateMode? autoValidateMode,
    Color cursorColor = Colors.black,
    TextStyle? style,
    TextInputAction? textInputAction,
    String? Function(String? value)? validator,
    Function(String value)? onFieldSubmitted,
    Function(String value)? onChanged,
    bool obscureText = false,
    bool autofocus = false,
    bool enabled = true,
    bool enableInteractiveSelection = true,
    bool enableSuggestions = false,
    Function? onLookupPressed,
    bool enableLookup = false,
    int? maxLines,
    Function? onTap,
    int? maxLength,
      Color? iconColor,
      Color? labelColor,
    IconButton? iconButton,
    List<TextInputFormatter>? inputFormatters,
    double? height = 43,
    TextInputType? keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 6.0,
      left: 8,
      right: 8,
    ),
    child: Container(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              onChanged: (val) {
                if (onChanged != null) {
                  onChanged(val);
                }
              },
              inputFormatters: inputFormatters,
              decoration: new InputDecoration(
                labelStyle: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500,color: labelColor??barColor),
                filled: true,
                labelText: labelText,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                contentPadding:
                    const EdgeInsets.only(bottom: 2.0, top: 2, left: 12),

                //prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                fillColor: Color(0XFFF3ECE7),
                disabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: barColor, width: 1),
                ),
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: barColor, width: 1),
                ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: barColor, width: 1),
                ),
                //fillColor: Colors.green
              ),
              maxLines: maxLines,
              readOnly: true,
              onTap: onTap != null
                  ? onTap as Function()
                  : () {
                      getErrorSnackBar('Uneditable');
                    },
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          enableLookup
              ? iconButton == null
                  ? IconButton(
                      icon: Icon(
                        Icons.search,
                        color: iconColor??barColor,
                      ),
                      onPressed: onLookupPressed != null
                          ? onLookupPressed as Function()
                          : null,
                    )
                  : iconButton
              : iconButton == null
                  ? IconButton(
                      icon: Icon(
                        Icons.search,
                        color: iconColor??Colors.white,
                      ),
                      onPressed: null,
                    )
                  : iconButton
        ],
      ),
    ),
  );
}

Widget getDisabledTextFieldWithoutLookup(
    {required TextEditingController controller,
    String? labelText,
    String suffixText = "",
    Widget? suffixIcon,
    Widget? prefixIcon,
    BuildContext? context,
    TextAlign? textAlign,
    FocusNode? focusNode,
    TextDirection? textDirection,
    Key? key,
    AutovalidateMode? autoValidateMode,
    Color cursorColor = Colors.black,
    TextStyle? style,
    TextInputAction? textInputAction,
    String? Function(String? value)? validator,
    Function(String value)? onFieldSubmitted,
    Function(String value)? onChanged,
    bool obscureText = false,
    bool autofocus = false,
    bool enabled = true,
    bool enableInteractiveSelection = true,
    bool enableSuggestions = false,
    Function? onLookupPressed,
    bool enableLookup = false,
    int? maxLines,
    Function? onTap,
    int? maxLength,
    IconButton? iconButton,
    List<TextInputFormatter>? inputFormatters,
    double? height = 43,
    double? fontSize = 14,
    TextInputType? keyboardType = TextInputType.text}) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: 6.0,
      left: 8,
      right: 8,
    ),
    child: Container(
      height: height,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              onChanged: (val) {
                if (onChanged != null) {
                  onChanged(val);
                }
              },
              inputFormatters: inputFormatters,
              decoration: new InputDecoration(
                labelStyle: GoogleFonts.poppins(
                    fontSize: fontSize, fontWeight: FontWeight.w500),
                filled: true,
                labelText: labelText,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                contentPadding:
                    const EdgeInsets.only(bottom: 2.0, top: 2, left: 12),

                //prefixIconConstraints: BoxConstraints(minWidth: 0,minHeight: 0),
                fillColor: Color(0XFFF3ECE7),
                disabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: barColor, width: 1),
                ),
                hoverColor: Colors.red,
                focusedBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: barColor, width: 1),
                ),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(color: barColor, width: 1),
                ),
                //fillColor: Colors.green
              ),
              maxLines: maxLines,
              readOnly: true,
              onTap: onTap != null
                  ? onTap as Function()
                  : () {
                      getErrorSnackBar('Uneditable');
                    },
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> getTimePopup({
  required BuildContext context,
  required TimeOfDay initialTime,
  required Function(TimeOfDay pickedTime) onTimePicked,
}) async {
  TimeOfDay? pickedTime = await showTimePicker(
      context: context,

      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      });
  if (pickedTime != null) {
    onTimePicked(pickedTime);
  }
}

FilteringTextInputFormatter getDecimalRegEx() {
  return FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*'));
}
FilteringTextInputFormatter getIntegerRegEx() {
  return  FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
}

TextInputType getDecimalKeyboardType() {
  return TextInputType.numberWithOptions(decimal: true);
}
