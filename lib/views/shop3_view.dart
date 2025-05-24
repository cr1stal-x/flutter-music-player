import 'package:flutter/material.dart';
import 'dart:async';
import '../models/song_model.dart';
import 'comment_view.dart';

class Shop3 extends StatefulWidget {

  //fields:
  Map selectedSong;
  Map selectedPerson;
  bool isPremium;

  //constructor
  Shop3({Key? test, required this.selectedSong, required this.selectedPerson, required this.isPremium}) : super(key: test);

  //making state
  @override
  State<Shop3> createState() => _Shop3State();
}

class _Shop3State extends State<Shop3> {

  //fields:
  final TextEditingController _rate = TextEditingController();
  final TextEditingController _comment = TextEditingController();
  bool downloadable = false;
  bool playable = false;
  bool rated = false;
  bool isPlaying = false;
  int givenRating = 0;
  String? comment;
  double progress = 0.0;
  Timer? _timer;

  //for test:
  int defaultRateCounts = 10;
  double credit = 10.0;

  Map<String, dynamic> mySong = {};
  Map<String, dynamic> person = {};
  Map<String, dynamic>? myComment;


  @override
  void initState() { //initialize some fields those need to start once
    super.initState();
    mySong = Map<String, dynamic>.from(widget.selectedSong ?? {});
    person = Map<String, dynamic>.from(widget.selectedPerson ?? {});
  }

  //methods:
  Widget showTheSong() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
            Text(
              mySong['rating'].toStringAsFixed(1),
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }

  void rateTheSong(double rate) {
    if(rated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("you rated before!")),
      );
      return;
    }

    double totalSum = mySong['rating'] * defaultRateCounts;
    defaultRateCounts++;
    mySong['rating'] = (totalSum + rate) / defaultRateCounts;

    givenRating = rate.toInt();
    rated = true;
    setState(() {});// update UI
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("rated successfully✅")),
    );
  }

  void downloadTheSong(Map<String, dynamic> song) {
    if(mySong['price'] == 0 || widget.isPremium || downloadable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("download successfully✅")),
      );
      setState(() {
        playable = true;
        downloadable = true;
      });
      //goto homePage

      Song fixedSong = Song(
        songName: mySong['songName'] ?? "Unknown",
        artistName: mySong['singer'] ?? "Unknown",
        albumArtImagePath: mySong['image'] ?? "assets/default.jpg",
        audioPath: mySong['audio'] ?? "assets/audio/default.mp3",
      );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => (song: fixedSong),
      //   ),
      // );

    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("this song is not free❌")),
      );
    }
  }

  void buyTheSong() {
    if(mySong['price'] != 0 && !widget.isPremium) {
      if(credit >= mySong['price']) {
        setState(() { //refresh
          credit -= mySong['price'];
          downloadable = true;
          //playable = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Song purchased successfully 🛒")),
        );
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("your credit is not enough❌")),
        );
      }
    }
  }

  void showCommentMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("your comment sent successfully")),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title:
         Text(
          "Song Details",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),

      ),
      body: SingleChildScrollView( //can scroll
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              showTheSong(),

              //rating stars:
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  int starIndex = index + 1;
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: starIndex <= givenRating ? Colors.amber : Colors.grey[400],
                    ),
                    onPressed: () {
                      if(rated == false) {
                        setState(() {
                          givenRating = starIndex;
                        });
                      }
                      rateTheSong(starIndex.toDouble());
                    },
                  );
                }),
              ),

              Text(
                'Your credit: \$${credit.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              if(mySong['price'] != 0 && !widget.isPremium && !downloadable)
                ElevatedButton(
                  onPressed: buyTheSong,
                  child: Text('Buy Song for \$${mySong['price'].toStringAsFixed(2)}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () => downloadTheSong(mySong),
                  child: Text('Download Song'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                    foregroundColor: Colors.white,
                  ),
                ),

              //play button
              if(playable)
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(isPlaying ? "Playing... 🎧" : "Paused ⏸️")),
                    );
                  },
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(isPlaying ? "Pause" : "Play"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPlaying ? Theme.of(context).colorScheme.inversePrimary : Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                  ),
                ),

              // نوار پخش
              if(playable)
                Slider(
                  value: currentPosition.toDouble(),
                  max: maxDuration.toDouble(),
                  onChanged: (value) {},
                ),

              SizedBox(height: 50), //change it to fix

              //comment box
              Container(
                margin: EdgeInsets.only(top: 32),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _comment,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'share your idea about the song...',
                          border: InputBorder.none,
                          isDense: true, // compact height
                        ),
                      ),
                    ),
                    //sending
                    IconButton(
                      onPressed: () {
                        if(_comment.text.trim() == null)
                          return;

                        setState(() {
                          myComment = {
                            "com": _comment.text.trim(),
                            "likes": "0",
                            "dislikes": "0",
                          };
                        });
                        _comment.clear();
                      },
                      icon: Icon(Icons.send, color: Colors.green),
                    ),
                  ],
                ),
              ),
              //commentPage button
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Comments(myComment: myComment),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
                child: Text("See Other Comments"),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    _rate.dispose();
    _comment.dispose();
    _timer?.cancel();
    super.dispose();
  }

  int currentPosition = 0;
  int maxDuration = 10;
}