import 'package:flutter/material.dart';
import 'package:musix/Auth.dart';
import 'package:provider/provider.dart';
import '../testClient.dart';

class Comments extends StatefulWidget {
  final int songId;
  const Comments({Key? key, required this.songId}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  String sortType = "likes";
  List<String> sortTypes = ["likes", "dislikes"];
  List<Map<String, dynamic>> comments = [];
  bool isLoading = true;
  final TextEditingController _commentController = TextEditingController();
  Map<int, bool> isEditing = {};
  Map<int, TextEditingController> editControllers = {};

  void dispose() {
    _commentController.dispose();
    editControllers.forEach((key, ctrl) => ctrl.dispose());
    super.dispose();
  }
  Future<void> updateComment(int commentId, String newContent) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final client = Provider.of<CommandClient>(context, listen: false);

    final response = await client.sendCommand(
      "updateComment",
      extraData: {
        "commentId": commentId,
        "newContent": newContent,
      },
    );

    if (response["status-code"] == 200) {
      setState(() {
        final index = comments.indexWhere((c) => c['id'] == commentId);
        if (index != -1) {
          comments[index]["content"] = newContent;
          isEditing[commentId] = false;
        }
      });
    }
  }


  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    try {
      final client = Provider.of<CommandClient>(context, listen: false);
      final response = await client.sendCommand(
        "getComments",
        extraData: {"songId": widget.songId},
      );

      if (response["status-code"] == 200) {
        setState(() {
          comments = List<Map<String, dynamic>>.from(response["comments"]);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading comments: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    if(!auth.isAuthenticated){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('login to your account to add comment')),
    );
    return;}
    final newComment = {
      "username": auth.username ?? "Unknown",
      "content": _commentController.text.trim(),
      "likes": "0",
      "dislikes": "0",
      "date": DateTime.now().toIso8601String(),
    };

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final client = Provider.of<CommandClient>(context, listen: false);
      final response = await client.sendCommand(
        "addComment", username: auth.username??'',
        extraData: {
          "songId": widget.songId,
          "comment": _commentController.text.trim(),
        },
      );

      if (response["status-code"] == 200) {
        setState(() {
          comments.insert(0, newComment);
          _commentController.clear();
        });
      }
    } catch (e) {
      debugPrint("Error adding comment: $e");
    }
  }

  List<Map<String, dynamic>> sort(String sortingMethod) {
    final sorted = [...comments];
    if (sortingMethod == "likes") {
      sorted.sort((a, b) =>
      int.parse(b["likes"].toString()) - int.parse(a["likes"].toString()));
    } else if (sortingMethod == "dislikes") {
      sorted.sort((a, b) => int.parse(b["dislikes"].toString()) -
          int.parse(a["dislikes"].toString()));
    }
    return sorted;
  }


  @override
  Widget build(BuildContext context) {
    final sortedComments = sort(sortType);
    final auth = Provider.of<AuthProvider>(context, listen: false);

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
          // Dropdown to sort
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
              style: const TextStyle(color: Colors.white),
              iconEnabledColor: Colors.white,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => sortType = newValue);
                }
              },
              items: sortTypes.map((sortOption) {
                return DropdownMenuItem(
                  value: sortOption,
                  child: Text('Sort by $sortOption'),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
              itemCount: sortedComments.length,
              itemBuilder: (context, index) {
                final comment = sortedComments[index];
                final commentId = comment['id'];
                final isOwner =
                auth.username != null && auth.username == comment['username'];

                if (isEditing[commentId] ?? false) {
                editControllers[commentId] ??=
                TextEditingController(text: comment['content']);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: editControllers[commentId],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => updateComment(
                            commentId,
                            editControllers[commentId]!.text.trim()),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            isEditing[commentId] = false;
                          });
                        },
                      ),
                    ],
                  ),
                );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              comment['username'] ?? "Unknown",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ), if (isOwner)
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () {
                                setState(() {
                                  isEditing[commentId] = true;
                                });
                              },
                            ),
                          if(isOwner)
                            IconButton(
                              icon: const Icon(Icons.delete, size: 18),
                              onPressed: () async {
                                final client = Provider.of<CommandClient>(context, listen: false);
                                final response = await client.sendCommand(
                                    "deleteComment",
                                    username: auth.username??"",
                                    extraData: {"commentId": comment["id"],
                                    });

                                if (response["status-code"] == 200) {
                                  setState(() {
                                    comments.removeWhere((c) => c["id"] == comment["id"]); // remove from UI
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Failed to delete comment")),
                                  );
                                }
                              },
                            ),
                          Text(
                            comment["created_at"] ?? "",
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),


                        ],
                      ),
                      const SizedBox(height: 4),
                      // Comment content
                      Text(
                        comment["content"] ?? "",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              final auth =
                              Provider.of<AuthProvider>(context, listen: false);
                              if (!auth.isAuthenticated) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Login to your account to rate.')),
                                );
                                return;
                              }
                              try {
                                final client = Provider.of<CommandClient>(context,
                                    listen: false);
                                final response = await client.sendCommand(
                                  "likeComment",
                                  extraData: {"commentId": comment['id']},
                                );
                                if (response["status-code"] == 200) {
                                  setState(() {
                                    comment["likes"] =
                                    (int.parse(comment["likes"].toString()) + 1);
                                  });
                                }
                              } catch (e) {
                                debugPrint("Error liking comment: $e");
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.thumb_up,
                                    color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                Text(comment["likes"].toString()),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          InkWell(
                            onTap: () async {
                              final auth =
                              Provider.of<AuthProvider>(context, listen: false);
                              if (!auth.isAuthenticated) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Login to your account to rate.')),
                                );
                                return;
                              }
                              try {
                                final client = Provider.of<CommandClient>(context,
                                    listen: false);
                                final response = await client.sendCommand(
                                  "dislikeComment",
                                  extraData: {"commentId": comment['id']},
                                );
                                if (response["status-code"] == 200) {
                                  setState(() {
                                    comment["dislikes"] = (int.parse(
                                        comment["dislikes"].toString()) +
                                        1);
                                  });
                                }
                              } catch (e) {
                                debugPrint("Error disliking comment: $e");
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.thumb_down,
                                    color: Colors.amber, size: 18),
                                const SizedBox(width: 4),
                                Text(comment["dislikes"].toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: addComment,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
