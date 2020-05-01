import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomListView extends StatefulWidget{
  List selectedevents;
  _CustomListViewState _customListViewState;
  CustomListView({Key key, this.selectedevents}) : super(key: key);
  @override
  _CustomListViewState createState() {
      _customListViewState=_CustomListViewState();
      return _customListViewState;
  }

  void ChangeList(List events){
    selectedevents=events;
    _customListViewState.ChangeState(events);
  }
}

class _CustomListViewState extends State<CustomListView> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  AnimatedIconData icon = AnimatedIcons.play_pause;
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        color: Colors.black12,
        child: ListView.builder(
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            itemCount: widget.selectedevents.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Dismissible(
                key: UniqueKey(),
                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {
                    widget.selectedevents.removeAt(index);
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
                        Text(widget.selectedevents[index].name,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text("${widget.selectedevents[index].getDuration()}",
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
                                widget.selectedevents.removeAt(index);
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

  void ChangeState(List events){
    setState(() {
      widget.selectedevents = events;
    });
  }
}
