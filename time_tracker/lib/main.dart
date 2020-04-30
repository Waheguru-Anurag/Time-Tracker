    import 'package:flutter/material.dart';
  import 'package:flutter/widgets.dart';
  import 'package:table_calendar/table_calendar.dart';
  import 'package:timetracker/Event.dart';

  void main() => runApp(MaterialApp(
    home: MyHomePage(),
  ));

  class MyHomePage extends StatefulWidget {
    @override
    _MyHomePageState createState() => _MyHomePageState();
  }

  class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
    AnimationController _animationController;
    CalendarController _calendarController;
    List _selectedevents;
    Map<DateTime,List> _events;
    DateTime _presentDay,_selectedDay;
    AnimatedIconData icon = AnimatedIcons.play_pause;
    bool isPlaying = false;
    BuildContext buildcontext;

    @override
    void initState() {
      super.initState();
      _animationController =  AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
      );
      _calendarController = CalendarController();
      _presentDay = DateTime.now();
      if(_events==null) {
        _events = {
          _presentDay: [],
          //_calendarController.selectedDay:[],
        };
      }
      _selectedevents = _events[_presentDay] ?? [];
    }

    Future<EventWidget> createAlertDialog(BuildContext context){
      TextEditingController Task = TextEditingController();
      TextEditingController Hour = TextEditingController();
      TextEditingController Minute = TextEditingController();
      TextEditingController Second = TextEditingController();

      return showDialog(context: context,builder: (context){
        return Form(
          child: AlertDialog(
            title: Text("Enter the Event"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                        child: Input(
                          hintText: "Name",
                          icon: Icons.event,
                          controller: Task,
                          cursorColor: Colors.blue,
                          textInputType: TextInputType.text,
                        )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Input(
                          hintText: "HH",
                          controller: Hour,
                          cursorColor: Colors.blue,
                          textAlign: TextAlign.center,
                          textInputType: TextInputType.number,
                        ),
                      ),
                      Expanded(
                        child: Input(
                          hintText: "MM",
                          controller: Minute,
                          cursorColor: Colors.blue,
                          textAlign: TextAlign.center,
                          textInputType: TextInputType.number,
                        )
                      ),
                      Expanded(
                        child: Input(
                          hintText: "SS",
                          controller: Second,
                          cursorColor: Colors.blue,
                          textAlign: TextAlign.center,
                          textInputType: TextInputType.number,
                        ),
                      ),
                    ],
                 )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Submit"),
                  elevation: 1.0,
                  textColor: Colors.blue,
                  hoverColor: Colors.blue,
                  textTheme: ButtonTextTheme.accent,
                  onPressed: (){
                        EventWidget eventwidget = new EventWidget(
                            Task.text.toString(), Hour.text.toString(),
                            Minute.text.toString(), Second.text.toString());
                        Navigator.of(context).pop(eventwidget);

                  },
                )
              ],
            ),
        );
        });
      }

    @override
    Widget build(BuildContext context) {
      buildcontext = context;
      return Scaffold(
        appBar: AppBar(
          title: Text("Time Tracker"),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TableCalendar(
                  calendarController: _calendarController,
                  calendarStyle: CalendarStyle(
                  todayColor: Colors.blue,
                  selectedColor: Colors.orange,
                ),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  initialCalendarFormat: CalendarFormat.week,
                  events: _events,
                  onDaySelected: _onDaySelected,
              ),
              Divider(
                color: Colors.grey,
                height: 0,
              ),
              // Expanded is used for resizing
              Flexible(
                child: _buildEventList(),
              )
            ],
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
              createAlertDialog(context).then((onValue) {
                if (onValue != null) {
                  _selectedDay = _SelectedDay();
                  List events = _events[_selectedDay] ?? [];
                  events.add(onValue);
                  _events[_selectedDay] = events;
                  _onDaySelected(_selectedDay, events);
                }
              });
          },
          child: Icon(Icons.add),
        ),
      );
    }

    // The logic behind this function is that when the _calendar.selectedDay method is invoked for the present day then
    // the Datetime Object's Time Parameters doesn't match with those of the presentDay as a result the Events are not saved
    // in the _Present Day event list.
    DateTime _SelectedDay(){
      if(compare(_calendarController.selectedDay, _presentDay))
        return _presentDay;
      else
        return _calendarController.selectedDay;
    }

    void _onDaySelected(DateTime day, List events) {
      print('CALLBACK: _onDaySelected');
      setState(() {
          _selectedevents=events;
      });
    }

    bool compare(DateTime dateTime1, DateTime dateTime2){
      int _date1,_month1,_year1;
      int _date2,_month2,_year2;

      _date1=dateTime1.day;
      _date2=dateTime2.day;
      _year1=dateTime1.year;
      _year2=dateTime2.year;
      _month1=dateTime1.month;
      _month2=dateTime2.month;

      if(_date1 == _date2 && _month1==_month2 && _year1==_year2)
        return true;

      return false;
    }

    Widget _buildEventList() {
      return Container(
        color: Colors.black12,
            child: ListView.builder(
              addAutomaticKeepAlives: true,
              shrinkWrap: true,
              itemCount: _selectedevents.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Dismissible(
                    key: UniqueKey(),
                    // Provide a function that tells the app
                    // what to do after an item has been swiped away.
                    onDismissed: (direction) {
                      // Remove the item from the data source.
                      setState(() {
                        _selectedevents.removeAt(index);
                      });
                    },
                      child: Container(
                        decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                      ),
                        margin: EdgeInsets.all(2.0),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                              GestureDetector(
                                onTap: (){
                                  if(isPlaying)
                                    icon = AnimatedIcons.play_pause;
                                  else
                                    icon = AnimatedIcons.pause_play;
                                  setState(() {
                                        isPlaying=!isPlaying;
                                    });
                                  },
                                  child: AnimatedIcon(
                                    icon: icon,
                                    progress: _animationController,
                                  )
                                ),
                                Text(_selectedevents[index].name,
                                    style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text("${_selectedevents[index].getDuration()}",
                                  style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                  ),
                                ),
                                Material(
                                  color: Colors.white,
                                  child: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          _selectedevents.removeAt(index);
                                          _events[_selectedDay] = _selectedevents;
                                        });
                                        },
                                      highlightColor: Colors.cyanAccent,
                                    ),
                              ),
                            ],
                          ),
                      ),
                  ),
                  );
                  }
                )
        );
      }


  }

  class Input extends StatelessWidget{
    final String hintText;
    final TextEditingController controller;
    final Color cursorColor;
    IconData icon;
    TextAlign textAlign;
    TextInputType textInputType;

    Input({Key key, this.hintText, this.controller, this.cursorColor, this.icon, this.textAlign,this.textInputType}) : super(key: key);

    @override
    Widget build(BuildContext buildContext){
      return TextField(
        textAlign: textAlign==null?TextAlign.start:textAlign,
        keyboardType: textInputType,
        decoration: InputDecoration(
            hintText: hintText,
            icon: Icon(icon)
        ),
        cursorColor: cursorColor,
        controller: controller,
      );
    }
  }

