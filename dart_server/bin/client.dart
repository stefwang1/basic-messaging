import 'dart:io';
import 'dart:typed_data';

Future<void> main() async {
  // 1. Create Socket and connect to server
  final socket = await Socket.connect("0.0.0.0", 3000);

  // 2. Inform user of connection
  print("Client: Connected to ${socket.remoteAddress.address}:${socket.remotePort}");

  // 3. Listen to Server
  socket.listen(
    (Uint8List data) {
      final serverResponse = String.fromCharCodes(data);
      print("Client $serverResponse");
    },
    onError: (error) {
      print("Client: $error");
      socket.destroy();
    },
    onDone: () {
      print("Client: Server left");
      socket.destroy();
    }
  );

  String? username;

  do {
    print("Client: Please enter a username");
    username = stdin.readLineSync();
  } while (username == null || username.isEmpty);

  socket.write(username);
}