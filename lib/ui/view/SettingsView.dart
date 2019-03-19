import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_challenge/actions/ActionEvents.dart';
import 'package:flutter_app_challenge/blocs/ActionBloc.dart';
import 'package:flutter_app_challenge/blocs/FetchJsonBloc.dart';
import 'package:flutter_app_challenge/constants/AppContstant.dart';
import 'package:flutter_app_challenge/constants/colors.dart';
import 'package:flutter_app_challenge/customUi/SegmentControlWidget.dart';
import 'package:flutter_app_challenge/models/UserData.dart';
import 'package:flutter_app_challenge/utils/SaveImageLocation.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:screenshot/screenshot.dart';

// ignore: must_be_immutable
class Settings extends StatelessWidget {
  bool _isLongPress = false;
  List<UserInfo> list = [];
  int sharedValue = 2;
  File imageFile;
  ScreenshotController screenshotController = ScreenshotController();
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;
    bloc.fetchAllUserData();
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: _getAppBarWidget(),
        body: StreamBuilder(
            stream: bloc.allData,
            builder: (context, AsyncSnapshot<UserData> snapshot) {
              if (snapshot != null && snapshot.hasData) {
                list = snapshot.data.data != null ? snapshot.data.data : null;
                return Screenshot(
                  controller: screenshotController,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      SafeArea(
                        child: Column(
                          children: <Widget>[
                            _tabBarWidget(),
                            _imageContainer(),
                            _labelContainer(),
                            _textContainer()
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  Widget _getAppBarWidget() {
    return PreferredSize(
        child: Container(
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                AppBar(
                  elevation: 0.0,
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).primaryColor,
                  actions: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => _captureScreenShot(),
                          child: Text(
                            saveLabel,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Text(
                    settingsLabel,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontFamily: fontBold,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _backButton()
              ],
            ),
          ),
        ),
        preferredSize: Size.fromHeight(50.0));
  }

  Widget _backButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(5.0),
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Color(0XFFFFFFFF),
              ),
              Text(
                backLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: whiteColor,
                    fontSize: 15.0,
                    fontFamily: fontBold,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabBarWidget() {
    return Center(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: SegmentControl(
          [
            SegmentControlView("Basics", Text("Basics")),
            SegmentControlView("Preferences", Text("Preferences")),
            SegmentControlView("Photos", Text("Photos")),
          ],
          activeTabIndex: sharedValue,
        ),
      ),
    );
  }

  Widget _imageContainer() {
    final bloc = ActionBloc();
    return StreamBuilder(
        stream: bloc.eventsBloc(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          return StreamBuilder(
              stream: bloc.longPress,
              initialData: _isLongPress,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  _isLongPress = snapshot.data;
                }
                return StreamBuilder(
                    stream: bloc.delete,
                    initialData: -1,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      return Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: InkWell(
                          onLongPress: () => bloc.longPressEventSink
                              .add(LongPressActionEvent()),
                          child: StaggeredGridView.countBuilder(
                            itemCount: list.length,
                            itemBuilder: (context, int index) => Stack(
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: _imageItem(index),
                                    ),
                                    Positioned(
                                      child: Opacity(
                                        opacity: _isLongPress ? 1.0 : 0.0,
                                        child: InkWell(
                                          onTap: () {
                                            if (_isLongPress) {
                                              bloc.deleteEventSink
                                                  .add(DeleteActionEvent());
                                              _deleteItem(index);
                                            }
                                          },
                                          child: _closeButton(),
                                        ),
                                      ),
                                      right: -2.0,
                                      bottom: -2.0,
                                    ),
                                  ],
                                ),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            primary: true,
                            reverse: false,
                            crossAxisCount: 3,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            staggeredTileBuilder: (int index) =>
                                new StaggeredTile.count(
                                    index == 0 ? 2 : 1, index == 0 ? 2 : 1),
                          ),
                        ),
                      );
                    });
              });
        });
  }

  Widget _closeButton() {
    return CircleAvatar(
      radius: 13.0,
      backgroundColor: Colors.white,
      child: Center(
        child: Image.asset(
          'assests/cross.png',
          color: Colors.red,
          height: 12.0,
          width: 12.0,
        ),
      ),
    );
  }

  Widget _labelContainer() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'PROFILE INFO',
            style:
                TextStyle(color: Colors.black87, fontStyle: FontStyle.normal),
          ),
          Text(
            ' #/300',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _textContainer() {
    return Container(
      color: Colors.grey[300],
      child: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 10, left: 20, right: 20),
            child: Text(
              list.length > 0 ? list[1].bio : '',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey[900],
                  fontFamily: 'fonts/montserrat-regular.otf'),
            ),
          ),
        ),
      ),
    );
  }

  void _deleteItem(int pos) {
    list[pos] != null ? list.removeAt(pos) : null;
  }

  void _captureScreenShot() async {
    screenshotController.capture().then((File image) {
      _openMailbox(image);
    }).catchError((onError) {
      print(onError);
    });
  }

  void _openMailbox(File path) async {
    imageFile = await SaveFile().saveImage(path);

    final Email email = Email(
      body: 'Please find the attachment of my phone screenshot.',
      subject: 'Screenshot',
      recipients: ['obrand@ingenio.com'],
      bcc: ['amit@brainmobi.com'],
      attachmentPath: imageFile.path,
    );

    await FlutterEmailSender.send(email);
  }

  Widget _imageItem(int pos) {
    return CachedNetworkImage(
      imageUrl: list.length > 0 ? list[pos].avatar : profilePlaceHolder,
      fit: BoxFit.cover,
      width: MediaQuery.of(context).size.width,
    );
  }
}
