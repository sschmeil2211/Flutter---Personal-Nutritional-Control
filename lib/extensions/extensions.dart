// Método de extensión para capitalizar la primera letra de una cadena
extension Capitalize on String {
  String capitalize() => "${this[0].toUpperCase()}${this.substring(1)}";
}