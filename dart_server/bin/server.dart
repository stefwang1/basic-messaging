import 'dart:io';
import 'dart:typed_data';

Future<void> main() async {
  // 1. Get free IP address
  final ip = InternetAddress.anyIPv4;

  // 2. Create Server Socket
  final server = await ServerSocket.bind(ip, 3000); 

  // 3. Inform user server is running
  print("Server is running on: ${ip.address}:3000");

  // 4. Make server listen
  server.listen((Socket event) {
    handleConnection(event);
  });
}

List<Socket> clients = [];

// 5. Listen for informatin from client, handle error cases, handle closing the connection
void handleConnection(Socket client) {
  print("Server: Connection from ${client.remoteAddress.address}:${client.remotePort}");
  client.listen(
    (Uint8List data) {
      final message = String.fromCharCodes(data);

      for (final client in clients) {
        client.write("Server: $message has joined the party!");
      }

      clients.add(client);
      client.write("Server: You are logged in as $message");
    },
    onError: (error) {
      print(error);
    },
    onDone: () {
      print("Server: Client left");
      client.close();
    }
  );
}