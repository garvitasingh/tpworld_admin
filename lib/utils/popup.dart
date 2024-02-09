import 'package:flutter/material.dart';

 String ServerKEY =
    'AAAA5MPJ628:APA91bGRAarBQKwNMajq2vTIZuEf_obLtOt8OMMStlU0oQyt0CZ59NM-FrwIagVXzb_GyGFZ-9f0TFNu8Th0MwN2XqTgt4A17GrtlReDZVVE7gLY0G6qtLF_fOqPHD2V7CDY9pzbhmgt';
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}
