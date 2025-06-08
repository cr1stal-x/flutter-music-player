import 'dart:convert';
import 'dart:io';

void main()async{
  CommandClient commandClient = CommandClient();
  await commandClient.connect();
  // commandClient.sendCommand('signUp', username:'testUser1',password:'1234');
  // commandClient.sendCommand('get');
  // await Future.delayed(Duration(seconds: 10));
  commandClient.sendCommand('update', username: 'testUser1', password: '1234', data: 'Update');
  commandClient.sendCommand('get');
  await Future.delayed(Duration(seconds: 10));
  commandClient.sendCommand('login', username:'testUser2',password:'12345');
  commandClient.sendCommand('get');
  await Future.delayed(Duration(seconds: 10));
  commandClient.sendCommand('update', username: 'testUser2', password: '12345', data: 'Update');
  commandClient.sendCommand('get');
// commandClient.sendCommand('delete');
}
class CommandClient{
  final String serverAddress ='127.0.0.1';
  final int serverPort=8080;
  late Socket socket;
  CommandClient();
  Future<void> connect() async{
    try{
      socket= await Socket.connect(serverAddress, serverPort);
      print('connected to: ${socket.remoteAddress.address}: ${socket.remotePort}');
      socket.listen((List <int> event){
        final response=utf8.decode(event);
        print('server response: $response');
      }, onError: (error){
        print('socket error: $error');
      },
      onDone: (){
        print('server closed');
      });
    }catch(e){
      print('error: $e');
    }
  }
  void sendCommand(String method, {String username="", String password="", String data=""}){
    try{
      Map<String,String> command={
        'method':method,
        'userName':username,
        'password':password,
        'data':data,
      };
      socket.write(jsonEncode(command)+"0");
    }catch(e){
      print('error $e');
    }
  }
}

