import 'package:intl/intl.dart';

DateTime getFormattedDateTime(String dateString){

  // Divide la cadena en partes usando el carácter '-'
  List<String> dateParts = dateString.split('-');

  // Convierte las partes a enteros
  int year = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int day = int.parse(dateParts[2]);

  // Crea un objeto DateTime
  DateTime dateTime = DateTime(year, month, day);

  // Obtiene el número del día
  return dateTime;
}

String getFormattedDay(String dateString){
  List<String> dateParts = dateString.split('-');

  // Convertir las partes a enteros
  int year = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);
  int day = int.parse(dateParts[2]);

  // Crear un objeto DateTime
  DateTime dateTime = DateTime(year, month, day);
  // Formatear la fecha en el formato deseado
  return DateFormat.yMMMMd().format(dateTime);
}