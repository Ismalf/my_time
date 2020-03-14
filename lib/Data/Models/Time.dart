class Time {
  int hours;
  int minutes;

  Time({this.hours = 00, this.minutes = 00});

  String toString() {
    return (this.hours < 10
            ? '0' + this.hours.toString()
            : this.hours.toString()) +
        ' : ' +
        (this.minutes < 10
            ? '0' + this.minutes.toString()
            : this.minutes.toString());
  }
}
