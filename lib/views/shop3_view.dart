import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../models/song_model.dart';
import 'comment_view.dart';

class Shop3 extends StatefulWidget {
  final Map selectedSong;
  final Map selectedPerson;
  final bool isPremium;

  Shop3({Key? key, required this.selectedSong, required this.selectedPerson, required this.isPremium}) : super(key: key);

  @override
  State<Shop3> createState() => _Shop3State();
}

class _Shop3State extends State<Shop3> {
  final TextEditingController _comment = TextEditingController();
  bool downloadable = false;
  bool playable = false;
  bool rated = false;
  bool isPlaying = false;
  int givenRating = 0;
  double progress = 0.0;

  Map<String, dynamic> mySong = {};
  Map<String, dynamic> person = {};
  List<Map<String, dynamic>> allComments = [];

  Socket? socket;

  @override
  void initState() {
    super.initState();
    mySong = Map<String, dynamic>.from(widget.selectedSong);
    person = Map<String, dynamic>.from(widget.selectedPerson);
    connectToServer();
    fetchCommentsAndRating();
  }

  void connectToServer() async {
    try {
      socket = await Socket.connect('127.0.0.1', 5000);
      socket!.listen((data) {
        final response = utf8.decode(data);
        handleServerResponse(response);
      });
    } catch (e) {
      print("Socket connection error: $e");
    }
  }

  void handleServerResponse(String response) {
    final Map<String, dynamic> jsonResponse = json.decode(response);
    if (jsonResponse['method'] == 'commentsList') {
      setState(() {
        allComments = List<Map<String, dynamic>>.from(jsonResponse['comments']);
      });
    } else if (jsonResponse['method'] == 'ratingUpdated') {
      setState(() {
        mySong['rating'] = jsonResponse['newRating'];
      });
    }
  }

  void fetchCommentsAndRating() {
    if (socket == null) return;
    final request = json.encode({
      "method": "getSongDetails",
      "songId": mySong['id'],
    });
    socket!.write(request + "\n");
  }

  void rateTheSong(int rate) {
    if (rated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You have already rated this song!")),
      );
      return;
    }
    givenRating = rate;
    rated = true;
    setState(() {});

    // Send rating to server
    final request = json.encode({
      "method": "rateSong",
      "songId": mySong['id'],
      "userId": person['id'],
      "rating": rate,
    });
    socket!.write(request + "\n");
  }

  void sendComment() {
    if (_comment.text.trim().isEmpty) return;
    final commentText = _comment.text.trim();
    _comment.clear();

    final request = json.encode({
      "method": "addComment",
      "songId": mySong['id'],
      "userId": person['id'],
      "comment": commentText,
    });
    socket!.write(request + "\n");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Your comment sent successfully ✅")),
    );
  }

  void downloadTheSong() {
    if (mySong['price'] == 0 || widget.isPremium || downloadable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download successful ✅")),
      );
      setState(() {
        playable = true;
        downloadable = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This song is not free ❌")),
      );
    }
  }

  void buyTheSong() {
    if (mySong['price'] != 0 && !widget.isPremium) {
      // simulate credit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Song purchased successfully 🛒")),
      );
      setState(() {
        downloadable = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Song Details",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              showTheSongWidget(),
              SizedBox(height: 8),
              buildRatingStars(),
              SizedBox(height: 20),
              if (mySong['price'] != 0 && !widget.isPremium && !downloadable)
                ElevatedButton(
                  onPressed: buyTheSong,
                  child: Text('Buy Song for \$${mySong['price'].toStringAsFixed(2)}'),
                )
              else
                ElevatedButton(
                  onPressed: downloadTheSong,
                  child: Text('Download Song'),
                ),
              if (playable)
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(isPlaying ? "Pause" : "Play"),
                ),
              if (playable)
                Slider(
                  value: progress,
                  max: 100,
                  onChanged: (v) {},
                ),
              SizedBox(height: 32),
              buildCommentBox(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Comments(myComment: allComments),
                    ),
                  );
                },
                child: Text("See Other Comments"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showTheSongWidget() {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage(mySong['image']),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          mySong['songName'] ?? '',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          mySong['singer'] ?? '',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.amber),
            SizedBox(width: 5),
            Text(mySong['rating'].toStringAsFixed(1), style: TextStyle(fontSize: 18)),
          ],
        ),
      ],
    );
  }

  Widget buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        int starIndex = index + 1;
        return IconButton(
          icon: Icon(
            Icons.star,
            color: starIndex <= givenRating ? Colors.amber : Colors.grey[400],
          ),
          onPressed: () => rateTheSong(starIndex),
        );
      }),
    );
  }

  Widget buildCommentBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _comment,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Share your idea about the song...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: sendComment,
            icon: Icon(Icons.send, color: Colors.green),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _comment.dispose();
    socket?.close();
    super.dispose();
  }
}
