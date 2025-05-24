import 'package:flutter/material.dart';
import 'package:musix/views/drawer.dart';
import 'package:musix/views/tracks_view.dart';
import 'package:provider/provider.dart';

import '../view_models/library_view_model.dart';
import 'Playlist_add_view.dart';
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => LibraryViewModel()..loadSongs(),
    child: Scaffold(
      appBar:AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle:true,
        title: Text('M U S I X'),
      ) ,
      drawer: MyDrawer(),
    body: Consumer<LibraryViewModel>(
    builder: (context, vm, _) {
    if (vm.loading) return Center(child: CircularProgressIndicator());

    return ListView(
    children: [Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 10,),
            FilledButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>TracksView()));}, child:Column(children: [SizedBox(height: 6,),Icon(Icons.queue_music_outlined,size: 60,),
            Text('Tracks'), SizedBox(height: 6,)],), ),

            FilledButton(onPressed: (){
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => FilterListScreen(
            //       title: "Albums",
            //       items: vm.albums,
            //       onItemSelected: (album) {
            //         var songs = vm.getSongsByAlbum(album);
            //         // Navigator.push(
            //         //   context,
            //         //   MaterialPageRoute(
            //         //     builder: (_) => SongsListScreen(songs, title: album),
            //         //   ),
            //         // );
            //       },
            //     ),
            //   ),
            //);
          }, child:Column(children: [SizedBox(height: 6,),Icon(Icons.album_rounded,size: 60,),
              Text('Server'), SizedBox(height: 6,)],) ),

            FilledButton(onPressed: (){
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => FilterListScreen(
              //       title: "Artists",
              //       items: vm.artists,
              //       onItemSelected: (artist) {
              //         var songs = vm.getSongsByArtist(artist);
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (_) => SongListScreen(title: artist, songs: songs,),
              //           ),
              //         );
              //       },
              //     ),
              //   ));
              }, child:Column(children: [SizedBox(height: 6,), Icon(Icons.person,size: 60,),
              Text('Artists'), SizedBox(height: 6,)],) ),
            SizedBox(width: 10,),

          ],
        ),
      SizedBox(height: 30,),
      Container(padding: EdgeInsets.all(10),color: Theme.of(context).colorScheme.inversePrimary,child: Center(child: Text('P L A Y     L I S T S', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),)),
        SizedBox(height: 20,),
            ListTile(
              leading: Icon(Icons.favorite, size: 50,),
              title: Text('Favorite songs', style: TextStyle(fontSize: 20),),
              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>FavoritesView())),
            ),

      ],
    ),],);}),
      floatingActionButton: FloatingActionButton(onPressed: (){
      },tooltip: 'Create a new playlist', child: Icon(Icons.add),),
    ));
  }
}
