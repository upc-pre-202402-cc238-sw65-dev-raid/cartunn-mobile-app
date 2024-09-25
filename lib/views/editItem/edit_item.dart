import 'package:flutter/material.dart';
import 'package:cartunn/views/editItem/uploadItem/upload_item.dart';
import 'package:cartunn/views/editItem/updateItem/update_item.dart';
import 'package:cartunn/views/editItem/removeItem/remove_item.dart';
import 'package:cartunn/views/editItem/notifyClient/notify_client.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              labelColor: Color(0xFF5766f5),
              unselectedLabelColor: Colors.black54,
              indicatorColor: Color(0xFF5766f5),
              tabs: [
                Tab(text: 'Upload Item'),
                Tab(text: 'Update Item'),
                Tab(text: 'Remove Item'),
                Tab(text: 'Notify Client'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  UploadItemPage(),
                  UpdateItemPage(),
                  RemoveItemPage(),
                  NotifyClientPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}