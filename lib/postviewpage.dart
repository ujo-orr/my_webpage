import 'package:flutter/material.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:go_router/go_router.dart';

import 'data/postdata.dart';

class PostViewPage extends ConsumerWidget {
  final String postId;

  const PostViewPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blogService = BlogService();
    final quillController = QuillController(
        document: Document(),
        selection: TextSelection.collapsed(offset: 0),
        readOnly: true,
        keepStyleOnNewLine: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post'),
        leading: IconButton(
          onPressed: () {
            context.go('/');
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: blogService.getPostById(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final post = snapshot.data!;
            final contentJson = post['content'] as List;
            quillController.document =
                Document.fromDelta(Delta.fromJson(contentJson));

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['title'] ?? 'No Title',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '카테고리 : ',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        post['category'] ?? 'No Category',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: QuillEditor(
                      controller: quillController,
                      scrollController: ScrollController(),
                      configurations: QuillEditorConfigurations(
                        readOnlyMouseCursor: SystemMouseCursors.basic,
                        sharedConfigurations: QuillSharedConfigurations(
                          extraConfigurations: {
                            QuillSharedExtensionsConfigurations.key:
                                QuillSharedExtensionsConfigurations()
                          },
                        ),
                        checkBoxReadOnly: true,
                        embedBuilders: FlutterQuillEmbeds.editorWebBuilders(
                            imageEmbedConfigurations:
                                QuillEditorImageEmbedConfigurations(
                              onImageClicked: (imageSource) => '',
                            ),
                            videoEmbedConfigurations:
                                QuillEditorWebVideoEmbedConfigurations()),
                      ),
                      focusNode: FocusNode(),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('포스트를 찾을 수 없습니다.'));
          }
        },
      ),
    );
  }
}
