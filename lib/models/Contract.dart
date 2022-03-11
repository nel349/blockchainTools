class Contract {
  final String name;
  String metadata;

  Contract({required this.name, required this.metadata});

  static Contract fromObject(Object? object) {
    Map? contracts = ((object as Map?)?['contracts'] as Map);
    Map<String, dynamic> a = contracts['Investment.sol'];
    Map<String, dynamic> b = a["Investment"];
    String metadata = b['metadata'];
    Contract result = Contract(name: a.entries.first.key, metadata: metadata);
    return result;
  }
}