// ignore_for_file: public_member_api_docs

class JsonItems {
  JsonItems._();
  static final largeJsonPath = '10k.json'.path;
}

extension on String {
  String get path {
    return 'assets/json/$this';
  }
}
