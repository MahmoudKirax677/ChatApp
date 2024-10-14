library app.globals;

import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'chatStream.dart';

var token = "";
var fcmToken = '';
var loginError;

bool loading = false;
var dayInfo = "";
var nameMyIso = "تركيا";
var nameMyIsoId = 2;
var codeMyIso;
var userId = -89;
Map messageNum = {};
var chatOpen = false;
var viewSearch = false;
var dialCodeMyIso = "+90";
var flagMyIso = const NetworkImage('http://layalinachat.com/assets/images/countries/b168.jpg');
var flagMyIsoForPhone;
late IO.Socket socket;
List<SelectedListItem> mainList = [];
List onlineList = [];
List chatList = [];
int coinsId = 0;
var appContext;
var callContext;


var phoneForPin;
var tokenForPin;


class SelectedListItem {
  int id;
  String name;
  SelectedListItem(this.id, this.name);
}