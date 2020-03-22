import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_input_screen.dart';

class UserProductItem extends StatelessWidget{
  final String id;
  final String title;
  final imageUrl;
  UserProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    // TODO: implement build
    return Column(children: <Widget>[ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.edit), onPressed: (){
              Navigator.of(context).pushNamed(EditInputScreen.routeName, arguments: id);
            }),
            IconButton(icon: Icon(Icons.delete, color: Colors.red,), onPressed: () async{
              try {
               await Provider.of<Products>(context, listen: false).deleteProduct(id);
              }catch(error){
                scaffold.showSnackBar(SnackBar(content: Text(error.toString()),));
              }
              
              }),
          ],
        ),
      ),

    )]);
  }
}