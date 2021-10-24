import 'package:flutter/cupertino.dart';

class Constans{
  static String get apiUrl => 'https://psychonauts-api.herokuapp.com/api/characters';
   static String camelToSentence(String text)  {
 
  if (text.length <= 1) {
    return text.toUpperCase();
  }
  final List<String> words = text.split(' ');
  final capitalizedWords = words.map((word) {
    if (word.trim().isNotEmpty) {
      final String firstLetter = word.trim().substring(0, 1).toUpperCase();
      final String remainingLetters = word.trim().substring(1);
      return '$firstLetter$remainingLetters';
    }
    return '';
  });
  return capitalizedWords.join(' ');
}
}