class Strafe {
  String name;
  DateTime date;
  String grund;
  double betrag;
  int id;

  Strafe.from(Strafe other)
      : betrag = other.betrag,
        name = other.name,
        date = other.date,
        grund = other.grund,
        id = other.id;

  Strafe();
}
