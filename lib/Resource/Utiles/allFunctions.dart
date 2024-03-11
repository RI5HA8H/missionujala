




import 'dart:convert';

 class allFunctions{


  String encryptToBase64(dynamic data) {
    if (data is int) {
      // Convert integer to string before encoding
      String stringValue = data.toString();
      List<int> utf8Bytes = utf8.encode(stringValue);
      return base64.encode(utf8Bytes);
    } else if (data is String) {
      List<int> utf8Bytes = utf8.encode(data);
      return base64.encode(utf8Bytes);
    } else {
      throw ArgumentError("Unsupported data type. Only int or String are allowed.");
    }
  }


  String decryptStringFromBase64(String base64String) {
    List<int> decodedBytes = base64.decode(base64String);
    String decodedString = utf8.decode(decodedBytes);
    return decodedString;
  }

  int decryptIntFromBase64(String base64String) {
    List<int> decodedBytes = base64.decode(base64String);
    String decodedString = utf8.decode(decodedBytes);

    try {
      // Attempt to convert the decoded string to an integer
      return int.parse(decodedString);
    } catch (e) {
      // Handle the case where conversion to integer fails
      throw FormatException("Failed to decode as an integer");
    }
  }


}