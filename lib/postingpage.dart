import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:go_router/go_router.dart';
import 'dart:io';

import 'data/postdata.dart';

class PostingPage extends ConsumerStatefulWidget {
  const PostingPage({super.key});

  @override
  ConsumerState<PostingPage> createState() => _PostingPageState();
}

class _PostingPageState extends ConsumerState<PostingPage> {
  final quill.QuillController _controller = quill.QuillController.basic();
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final BlogService _blogService = BlogService();

  File? imageFile; // 이미지 파일
  File? videoFile; // 동영상 파일

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('POSTING PAGE')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 600,
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Title',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 600,
                  child: TextField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Category',
                    ),
                  ),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  quill.QuillToolbar.simple(controller: _controller),
                  IconButton(onPressed: () {}, icon: Icon(Icons.file_open)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 600,
                  height: 600,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: quill.QuillEditor(
                    controller: _controller,
                    scrollController: ScrollController(),
                    configurations: quill.QuillEditorConfigurations(),
                    focusNode: FocusNode(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final title = titleController.text;
                  final category = categoryController.text;
                  final contentJson = _controller.document.toDelta().toJson();

                  if (title.isNotEmpty && category.isNotEmpty) {
                    await _blogService.uploadPost(
                      title: title,
                      category: category,
                      quillController: _controller,
                      quillContent: contentJson,
                      imageFile: imageFile, // 선택한 이미지 파일
                      videoFile: videoFile, // 선택한 동영상 파일
                    );
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('포스트가 업로드되었습니다!')),
                        );
                        context.go('/'); // 업로드 후 홈으로 이동
                      },
                    );
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('제목과 카테고리를 모두 입력해주세요.')),
                        );
                      },
                    );
                  }
                },
                child: Text('UPLOAD'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
