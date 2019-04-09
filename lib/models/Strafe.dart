class Strafe {
  String name;
  DateTime date;
  String grund;
  bool payed;
  double betrag;
  int id;

  Strafe.from(Strafe other)
      : betrag = other.betrag,
        name = other.name,
        date = other.date,
        grund = other.grund,
        payed = other.payed,
        id = other.id;

  Strafe();

  @override
  String toString() {
    return "Name: ${this.name} Betrag: ${this.betrag}";
  }
}
