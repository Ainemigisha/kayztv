class Program {
  int id;
  String name;

  Program(
      {this.id,
        this.name});

  factory Program.fromJson(Map<String, dynamic> map) {
    return Program(
      id: map['id'], 
      name: map['name'], 
    );
  }

  String get getName {
    return name;
  }

  int get getId {
    return id;
  }
  
  
}
