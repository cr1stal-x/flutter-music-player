import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  final Map<String, dynamic>? myComment;
  const Comments({Key? test, this.myComment}) : super(key: test);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  String sortType = "likes"; //default

  List<String> sortTypes = ["likes", "dislikes"];

  List<Map<String, dynamic>> comments = [
    {
      "com": "very good",
      "likes": "10",
      "dislikes": "2",
    },
    {
      "com": "can be better",
      "likes": "4",
      "dislikes": "15",
    },
    {
      "com": "I love it so much",
      "likes": "20",
      "dislikes": "6",
    },
    {
      "com": "the best music I heard",
      "likes": "13",
      "dislikes": "4",
    },
  ];

  @override
  void initState() {
    super.initState();
    addMyComment();
  }

  void addMyComment() {
    if(widget.myComment != null) {
      comments.insert(0, widget.myComment!);
    }
  }

  List<Map<String, dynamic>> sort(String sortingmethod, List<Map<String, dynamic>> coms) {
    List<Map<String, dynamic>> sortedList = coms;

    switch(sortingmethod) {
      case "likes" :
        for(int i = 0; i < coms.length - 1; i++) {
          for(int j = 0; j < coms.length - i - 1; j++) {
            if(int.parse(coms[j]['likes']) < int.parse(coms[j + 1]['likes'])) {
              Map<String, dynamic> temp = coms[j];
              coms[j] = coms[j + 1];
              coms[j + 1] = temp;
            }
          }
        }
        break;

      case "dislikes" :
        for(int i = 0; i < coms.length - 1; i++) {
          for(int j = 0; j < coms.length - i - 1; j++) {
            if(int.parse(coms[j]['dislikes']) < int.parse(coms[j + 1]['dislikes'])) {
              Map<String, dynamic> temp = coms[j];
              coms[j] = coms[j + 1];
              coms[j + 1] = temp;
            }
          }
        }
        break;
    }
    return sortedList;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sortedComments = sort(sortType, comments);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title:
        Text("Comments",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButtonFormField<String>( //scrollAble list
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
                if(newValue != null) {
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
          Expanded(
            child: ListView.builder(
              itemCount: sortedComments.length,
              itemBuilder: (context, index) {
                var comment = sortedComments[index];
                return ListTile(
                  title: Text(comment["com"]),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              int currentLikes =
                                  int.tryParse(comment["likes"]) ?? 0;
                              comment["likes"] = (currentLikes + 1).toString();
                            });
                          },
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
                          onTap: () {
                            setState(() {
                              int currentDislikes =
                                  int.tryParse(comment["dislikes"]) ?? 0;
                              comment["dislikes"] = (currentDislikes + 1).toString();
                            });
                          },
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
}
