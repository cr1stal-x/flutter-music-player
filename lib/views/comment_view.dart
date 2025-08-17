import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

class Comments extends StatefulWidget {
  final int songId;
  final int userId;
  const Comments({Key? key, required this.songId, required this.userId}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  String sortType = "likes"; // default sorting
  List<String> sortTypes = ["likes", "dislikes"];
  List<Map<String, dynamic>> comments = [];
  Socket? socket;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() async {
    try {
      socket = await Socket.connect('127.0.0.1', 5000);
      socket!.listen((data) {
        final response = utf8.decode(data);
        handleServerResponse(response);
      });
      fetchComments();
    } catch (e) {
      print("Socket connection error: $e");
    }
  }

  void fetchComments() {
    if (socket == null) return;
    final request = json.encode({
      "method": "getComments",
      "songId": widget.songId,
    });
    socket!.write(request + "\n");
  }

  void handleServerResponse(String response) {
    final Map<String, dynamic> jsonResponse = json.decode(response);
    switch (jsonResponse['method']) {
      case 'commentsList':
        setState(() {
          comments = List<Map<String, dynamic>>.from(jsonResponse['comments']);
        });
        break;
      case 'likeUpdated':
      case 'dislikeUpdated':
        setState(() {
          for (var c in comments) {
            if (c['id'] == jsonResponse['commentId']) {
              c['likes'] = jsonResponse['likes'].toString();
              c['dislikes'] = jsonResponse['dislikes'].toString();
              break;
            }
          }
        });
        break;
      case 'commentAdded':
        setState(() {
          comments.insert(0, jsonResponse['comment']);
        });
        break;
    }
  }

  void likeComment(Map<String, dynamic> comment) {
    final request = json.encode({
      "method": "likeComment",
      "commentId": comment['id'],
      "userId": widget.userId,
    });
    socket!.write(request + "\n");
  }

  void dislikeComment(Map<String, dynamic> comment) {
    final request = json.encode({
      "method": "dislikeComment",
      "commentId": comment['id'],
      "userId": widget.userId,
    });
    socket!.write(request + "\n");
  }

  void addComment(String text) {
    if (text.trim().isEmpty) return;
    final request = json.encode({
      "method": "addComment",
      "songId": widget.songId,
      "userId": widget.userId,
      "comment": text.trim(),
    });
    socket!.write(request + "\n");
  }

  List<Map<String, dynamic>> getSortedComments() {
    List<Map<String, dynamic>> sortedList = List.from(comments);
    sortedList.sort((a, b) {
      int aVal = int.parse(a[sortType]);
      int bVal = int.parse(b[sortType]);
      return bVal.compareTo(aVal);
    });
    return sortedList;
  }

  @override
  Widget build(BuildContext context) {
    final sortedComments = getSortedComments();
    final TextEditingController _commentController = TextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Comments",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButtonFormField<String>(
              value: sortType,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              dropdownColor: Theme.of(context).colorScheme.secondary,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.white,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    sortType = newValue;
                  });
                }
              },
              items: sortTypes.map((String sortOption) {
                return DropdownMenuItem<String>(
                  value: sortOption,
                  child: Text('Sort by $sortOption'),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final text = _commentController.text;
                    if (text.trim().isEmpty) return;
                    addComment(text);
                    _commentController.clear();
                  },
                  icon: Icon(Icons.send, color: Colors.green),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: sortedComments.length,
              itemBuilder: (context, index) {
                final comment = sortedComments[index];
                return ListTile(
                  title: Text(comment["com"]),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => likeComment(comment),
                          child: Row(
                            children: [
                              Icon(Icons.thumb_up, color: Colors.amber),
                              SizedBox(width: 4),
                              Text(comment["likes"]),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        InkWell(
                          onTap: () => dislikeComment(comment),
                          child: Row(
                            children: [
                              Icon(Icons.thumb_down, color: Colors.amber),
                              SizedBox(width: 4),
                              Text(comment["dislikes"]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    socket?.close();
    super.dispose();
  }
}
