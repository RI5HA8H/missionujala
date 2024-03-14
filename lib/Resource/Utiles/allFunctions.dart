

import 'dart:convert';
import 'dart:core';
import 'package:encrypt/encrypt.dart';



 class allFunctions{


  String encryptToBase64(String plainText) {
    final encrypter = Encrypter(AES(Key.fromUtf8('kk5dkld4G44jsloG'), mode: AESMode.ecb));
    final encrypted = encrypter.encrypt(plainText);
    return encrypted.base64;
  }


  String decryptStringFromBase64(String encryptedBase64) {
    final encrypter = Encrypter(AES(Key.fromUtf8('kk5dkld4G44jsloG'), mode: AESMode.ecb));
    final encrypted = Encrypted.fromBase64(encryptedBase64);
    final decrypted = encrypter.decrypt(encrypted);
    return decrypted;
  }



}