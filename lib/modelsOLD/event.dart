class Event{
  String location;
  String title;
  String clothes;
  DateTime timepoint;
  int id;

  String getTitle(){
    return this.title;
  }

  @override
  String toString() {
    return this.title + "\t " + this.location;
  }
}