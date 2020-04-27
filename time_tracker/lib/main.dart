  import 'package:flutter/material.dart';
  import 'package:flutter/widgets.dart';
  import 'package:table_calendar/table_calendar.dart';
  import 'package:timetracker/Event.dart';

  void main() => runApp(MyApp());

  class MyApp extends StatelessWidget {
    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      );
    }
  }

  class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title}) : super(key: key);
    final String title;

    @override
    _MyHomePageState createState() => _MyHomePageState();
  }

  class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
    AnimationController _animationController;
    CalendarController _calendarController;
    List _selectedevents;
    Map<DateTime,List> _events;
    DateTime _selectedDay;
    AnimatedIconData icon = AnimatedIcons.play_pause;
    bool isPlaying = false;

    @override
    void initState() {
      super.initState();
      _animationController =  AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
      );
      _calendarController = CalendarController();
      _selectedDay = DateTime.now();
      if(_events==null) {
        _events = {
          _selectedDay: [],
          //_calendarController.selectedDay:[],
        };
      }
      _selectedevents = _events[_selectedDay] ?? [];
    }

    Future<EventWidget> createAlertDialog(BuildContext context){
      TextEditingController Task = TextEditingController();
      TextEditingController Hour = TextEditingController();
      TextEditingController Minute = TextEditingController();
      TextEditingController Second = TextEditingController();

      return showDialog(context: context,builder: (context){
        return AlertDialog(
          title: Text("Enter the Event"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                        icon: Icon(Icons.event),
                        hintText: "Name"
                      ),
                        cursorColor: Colors.blue,
                        controller: Task,
                      )
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "HH"
                        ),
                        cursorColor: Colors.blue,
                        controller: Hour,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: "MM"
                        ),
                        cursorColor: Colors.blue,
                        controller: Minute,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            hintText: "SS"
                        ),
                        cursorColor: Colors.orange,
                        controller: Second,
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
                  Navigator.of(context).pop(new EventWidget(Task.text.toString(), Hour.text.toString(), Minute.text.toString(), Second.text.toString()));
                },
              )
            ],
          );
        });
      }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Time Tracker"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              Expanded(child: _buildEventList()),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            createAlertDialog(context).then((onValue){
              if(compare(_calendarController.selectedDay, _selectedDay)) {
                final events = _events[_selectedDay] ?? [];
                events.add(onValue);
                _events[_selectedDay] = events;
                _onDaySelected(_selectedDay.toLocal(), events);
              }
              else{
                final events = _events[_calendarController.selectedDay
                    .toLocal()] ?? [];
                events.add(onValue);
                _events[_calendarController.selectedDay.toLocal()] = events;
                _onDaySelected(_calendarController.selectedDay.toLocal(), events);
              }
            });
          },
          child: Icon(Icons.add),
        ),
      );
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
      String image = 'assets/download.png';
      return Container(
        color: Colors.black12,
            child: ListView.builder(
              itemCount: _selectedevents.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Dismissible(
                    key: Key(_selectedevents[index].name),
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
                          //backgroundBlendMode: BlendMode.clear
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
                                Text("${_selectedevents[index].hour}:${_selectedevents[index].minute}:${_selectedevents[index].second}",
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
                                        if(compare(_calendarController.selectedDay, _selectedDay)) {
                                          _events[_selectedDay] = _selectedevents;
                                        }
                                        else{
                                          _events[_calendarController.selectedDay.toLocal()] = _selectedevents;
                                        }
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
