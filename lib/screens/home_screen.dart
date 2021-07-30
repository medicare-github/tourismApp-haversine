import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../allNotifier/authNotifier.dart';
import '../widgets/widgets.dart';
import '../allNotifier/destinationNotifier.dart';
import '../allNotifier/newDestNotifier.dart';
import '../api/destinationApi.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({this.notifRating});
  final notifRating;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var destination = [];

  @override
  void initState() {
    // TODO: implement initState
    DestinationNotifier destinationNotifier =
        Provider.of<DestinationNotifier>(context, listen: false);
    NewDestNotifier newDestNotifier =
        Provider.of<NewDestNotifier>(context, listen: false);

    getDestinations(destinationNotifier);
    getNewDestinations(newDestNotifier);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    DestinationNotifier destinationNotifier =
        Provider.of<DestinationNotifier>(context);
    NewDestNotifier newDestNotifier = Provider.of<NewDestNotifier>(context);
    String name = authNotifier.user.displayName;

    Future<void> _refreshList() async {
      getDestinations(destinationNotifier);
      getNewDestinations(newDestNotifier);
    }

    return Scaffold(
      body: new RefreshIndicator(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 30),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 40.0),
                child: Text(
                  "Welcome " + name + " to nearby tourisms application",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 2.0,
                      bottom: 2.0,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                ),
              ),
              DestinationCarousel(),
              NewTourisms(),
              widget.notifRating != null
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 10),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.green[100],
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.done_all,
                              size: 40,
                            ),
                            Text(
                              widget.notifRating + " Succees add rating ",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        onRefresh: _refreshList,
      ),
    );
  }
}
