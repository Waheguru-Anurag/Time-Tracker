class EventWidget{
  String name;
  Duration duration;

  EventWidget(String name, String hour, String minute, String second){
    this.name=name;
    duration = new Duration(hours: int.parse(hour), minutes: int.parse(minute), seconds: int.parse(second));
  }

  String getDuration(){
    String text = duration.toString();
    int index = text. lastIndexOf('.');
    text = text.substring(0,index);
    return text;
  }
}
