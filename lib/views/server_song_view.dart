import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../Auth.dart';
import '../testClient.dart';
import 'comment_view.dart';

class ServerSongView extends StatefulWidget {
  final song;
  const ServerSongView({super.key,required this.song});

  @override
  State<ServerSongView> createState() => _ServerSongViewState();
}

class _ServerSongViewState extends State<ServerSongView> {
  List<Map<String, dynamic>> songs = [];
  bool isLoading = true;
  String? error;
  int newRating=0;
  bool rated=false;

  @override
  void initState() {
    super.initState();
  }


  Future<bool> _downloadSong(Map<String, dynamic> song) async {
    final songId = song['id'];
    final songTitle = (song['title'] ?? 'Unknown').toString().replaceAll(' ', '_');

    final client = Provider.of<CommandClient>(context, listen: false);
    final response = await client.sendCommand(
      'DownloadSong',
      extraData: {'songId': songId},
    );

    if (response['status-code'] == 200) {
      final String? base64Data = response['song_base64'];

      if (base64Data != null) {
        Uint8List bytes = base64Decode(base64Data);

        var status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("❌ Storage permission denied")),
          );
          return false;
        }

        Directory? downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          downloadsDir = await getExternalStorageDirectory();
        }
        final musixDir = Directory("${downloadsDir!.path}/Musix");
        if (!await musixDir.exists()) {
          await musixDir.create(recursive: true);
        }

        final filePath = "${musixDir.path}/$songTitle.mp3";
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ $songTitle saved at $filePath")),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ No song data in response')),
        );
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Failed to download song')),
      );
      return false;

    }
  }

  Uint8List? decodeBase64ImageSafely(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    try {
      String normalized = base64.normalize(base64String);
      return base64Decode(normalized);
    } catch (e) {
      print("Error decoding base64 image: $e");
      return null;
    }
  }

  void rateSong(int rating) async {
    if(rated){
    setState(() {
      newRating = rating;
    });}}
  @override
  Widget build(BuildContext context) {
    final title = widget.song['title'] ?? 'Unknown Title';
    final price = widget.song['price'] != null ? widget.song['price'].toString() : 'N/A';
    final rating=widget.song['rating']??0;
    final ratingCount=widget.song['rating_count'];
    final coverBase64 = widget.song['cover_base64'];
    final coverBytes = decodeBase64ImageSafely(coverBase64);
    final client = Provider.of<CommandClient>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              coverBytes != null
                  ? Image.memory(
                coverBytes,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              )
                  : Container(
                width: 250,
                height: 250,
                color: Colors.grey[300],
                child: const Icon(
                  Icons.music_note,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Price: \$ $price',
                style: const TextStyle(fontSize: 22),
              ),
              Text("download times: ${widget.song['download_time']}", style: TextStyle(fontSize: 20),),
              SizedBox(height: 30,),
              Text(
                "rating: ${rating.toStringAsFixed(2)} / 5 ($ratingCount)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),

              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  int starIndex = index + 1;
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: starIndex <= newRating ? Colors.amber : Colors.grey[400],
                    ),
                    onPressed: () async {
                      if(!auth.isAuthenticated){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('login to your account to rate.')),
                        );
                        return;
                      }
                      if(!rated){
                        rated=true;
                        rateSong(starIndex);
                        final response= await client.sendCommand("rate", extraData: {"rating":newRating, "songId": widget.song['id']});
                      if(response['status-code']==200){
                        final res=await client.sendCommand("getRating", extraData: {"songId":widget.song['id']});
                        setState(() {
                          widget.song['rating'] = res['rate']['rating'];
                          widget.song['rating_count'] = res['rate']['ratingCount'];
                        });
                      }}


                    },
                  );
                }),
              ),
              SizedBox(height: 8,),
              ElevatedButton(
                onPressed: () async {
                  if(!auth.isAuthenticated){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('login to your account to download songs.')),
                    );
                    return;
                  }
                  double parsed=double.parse(price);
                  if(auth.isVip??false){
                    bool downloaded=await _downloadSong(widget.song);
                    if(downloaded){
                      setState(() {
                        widget.song['download_time']+=1;
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('song is now accessible via VIP access.')),
                  );


                  }else{
                    if((auth.credit??0)<parsed){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('credit is not enough.')),
                      );
                    }else{
                      bool downloaded=await _downloadSong(widget.song);
                      if(downloaded){

                        final newCredit=(auth.credit??0)-parsed;
                        final response = await client.sendCommand(
                          'Update',
                          extraData: {"credit": newCredit},
                        );

                        if (response['status-code'] == 200) {
                          auth.updateField("credit", newCredit);
                        } else {
                          print("Update failed: ${response['message']}");
                        }
                        setState(() {
                          widget.song['download_time']+=1;
                        });
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Song is now accessible via credit payment.')),
                    );




                    }
                  }

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding: EdgeInsets.symmetric(
                      horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('DOWNLOAD', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700)),
              ),
              SizedBox(height: 10,),
              ElevatedButton(onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Comments(songId: widget.song['id']),
                  ),
                );
                 },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding: EdgeInsets.symmetric(
                      horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('COMMENTS', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
