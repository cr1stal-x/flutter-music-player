import 'package:flutter/material.dart';
import 'package:musix/views/shop3_view.dart';

class Shop2 extends StatefulWidget {

  //fields:
  String category;
  double credit = 10;
  bool isPremium = false;

  //constructor:
  Shop2({Key? test, required this.category}) : super(key: test);

  //making state for this page:
  @override
  State<Shop2> createState() => _Shop2State();
}

class _Shop2State extends State<Shop2> {

  //fields:
  String selectedSortType = "rating";

  //sortType??
  List<String> sortTypes = ["rating", "price", "downloads"];

  Map<String, dynamic> person = {
    'name' : 'sara',
    'totalCredit' : '10',
    'isPremium' : 'normal',
  };

  //just for test as server!
  List<Map<String, dynamic>> songs = [
    {
      'songName': 'Saghi',
      'singer': 'Hayedeh',
      'rating': 5.0,
      'downloads': 5000,
      'price': 0.0,
      'image': 'assets/images/myMusic.jpg',
    },

    {
      'songName': 'Betars',
      'singer': 'Mohsen Yeganeh',
      'rating': 4.7,
      'downloads': 1500,
      'price': 0.0,
      'image': 'assets/images/myMusic.jpg',
    },

    {
      'songName': 'Jome',
      'singer': 'Farhad',
      'rating': 4.9,
      'downloads': 3400,
      'price': 5.0,
      'image': 'assets/images/myMusic.jpg',
    },

    {
      'songName': 'Medad Rangi',
      'singer': 'Ebi',
      'rating': 4.1,
      'downloads': 1900,
      'price': 2.7,
      'image': 'assets/images/myMusic.jpg',
    },

    {
      'songName': 'Shahr Ashoob',
      'singer': 'Reza Sadeghi',
      'rating': 3.9,
      'downloads': 1340,
      'price': 0.0,
      'image': 'assets/images/myMusic.jpg',
    },

    {
      'songName': 'Boye Gisoo',
      'singer': 'Alireza Ghorbani',
      'rating': 4.6,
      'downloads': 4600,
      'price': 3.4,
      'image': 'assets/images/myMusic.jpg',
    },

    {
      'songName': 'Tavan',
      'singer': 'Ehsan Khaje Amiri',
      'rating': 3.8,
      'downloads': 900,
      'price': 1.2,
      'image': 'assets/images/myMusic.jpg',
    },

    {
      'songName': 'Siyah Cheshmoon',
      'singer': 'Hayedeh',
      'rating': 4.8,
      'downloads': 7800,
      'price': 0.0,
      'image': 'assets/images/myMusic.jpg',
    },

    {
      'songName': 'Alame Eshgh',
      'singer': 'Homeyra',
      'rating': 4.5,
      'downloads': 5700,
      'price': 0.0,
      'image': 'assets/images/myMusic.jpg',
    },

    {
      'songName': 'Nazar Karde',
      'singer': 'Mohammad Alizadeh',
      'rating': 4.1,
      'downloads': 1270,
      'price': 3.8,
      'image': 'assets/images/myMusic.jpg',
    },
  ];

  TextEditingController searchBox = TextEditingController();

  //methods:
  Widget showSongsList(Map<String,dynamic> songs) {
    return ListTile( //standard method to show lists
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      //cover image
      leading: ClipRRect( //leading: could be image or icon _ ClipRRect: cut corners
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          songs['image'],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        songs['songName'],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${songs['singer']} - ${songs['rating']}'),
      onTap: () { //click to go next page
        Navigator.push(
          context, //now page _ address necessary
          MaterialPageRoute(
            builder: (context) => Shop3( //create Shop3 widget
              selectedSong: songs,
              selectedPerson: person,
              isPremium: false,
              // widget.isPremium,
            ),
          ),
        );
      },
    );
  }


  List<Map<String, dynamic>> filter_select() {
    String searching = searchBox.text.toLowerCase(); //better to lowercase it
    List<Map<String, dynamic>> filteredSongs = []; //should have first value

    for(int i = 0; i < songs.length; i++) {
      String songName = songs[i]['songName'].toString().toLowerCase();
      if(songName.contains(searching)) {
        filteredSongs.add(songs[i]);
      }
    }
    return filteredSongs;
  }

  List<Map<String, dynamic>> sort(String sortingmethod, List<Map<String, dynamic>> filtereds) {
    switch(sortingmethod) {
      case "rating" :
        for(int i = 0; i < filtereds.length - 1; i++) {
          for(int j = 0; j < filtereds.length - i - 1; j++) {
            if(filtereds[j]['rating'] < filtereds[j + 1]['rating']) {
              Map<String, dynamic> temp = filtereds[j];
              filtereds[j] = filtereds[j + 1];
              filtereds[j + 1] = temp;
            }
          }
        }
        break;

      case "price":
        for(int i = 0; i < filtereds.length; i++) {
          for(int j = 0; j < filtereds.length - i - 1; j++) {
            if(filtereds[j]['price'] < filtereds[j + 1]['price']) {
              Map<String, dynamic> temp = filtereds[j];
              filtereds[j] = filtereds[j + 1];
              filtereds[j + 1] = temp;
            }
          }
        }
        break;

      case "downloads":
        for(int i = 0; i < filtereds.length; i++) {
          for(int j = 0; j < filtereds.length - i - 1; j++) {
            if(filtereds[j]['downloads'] < filtereds[j + 1]['downloads']) {
              Map<String, dynamic> temp = filtereds[j];
              filtereds[j] = filtereds[j + 1];
              filtereds[j + 1] = temp;
            }
          }
        }
        break;
    }
    return filtereds;
  }

  void do_sort(String sortType) {
    List<Map<String, dynamic>> filtered = filter_select();
    sort(sortType, filtered);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredSongs = sort(selectedSortType, filter_select(),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          widget.category,
          style: TextStyle(
            color:  Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [

          //searchBox
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchBox,
              decoration: InputDecoration(
                hintText: 'Search song name...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          //sortButton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField<String>(
              value: selectedSortType,
              decoration: InputDecoration(
                filled: true,
                fillColor:  Theme.of(context).colorScheme.primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              dropdownColor:  Theme.of(context).colorScheme.primary,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.white,
              onChanged: (String? newValue) {
                if(newValue != null) {
                  setState(() {
                    selectedSortType = newValue;
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

          //songsList
          Expanded( //rest of the page
            child: ListView.builder(
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                return showSongsList(filteredSongs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchBox.dispose();
    super.dispose();
  }
}