import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class PostingPage extends ConsumerStatefulWidget {
  const PostingPage({super.key});

  @override
  ConsumerState<PostingPage> createState() => _PostingPageState();
}

class _PostingPageState extends ConsumerState<PostingPage> {
  // Quill 컨트롤러 및 FocusNode
  final quill.QuillController _controller = quill.QuillController.basic();
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('POSTING PAGE')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 600, // 원하는 크기 설정
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Title',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Quill Toolbar (리치 텍스트 포맷 버튼)
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  quill.QuillToolbar.simple(controller: _controller),
                  IconButton(onPressed: () {}, icon: Icon(Icons.file_open)),
                ],
              ),

              SizedBox(height: 10),
              // Quill 에디터 (리치 텍스트 입력 필드)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 600, // 원하는 크기 설정
                  height: 600,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: quill.QuillEditor(
                    configurations: quill.QuillEditorConfigurations(),
                    controller: _controller,
                    scrollController: ScrollController(),
                    focusNode: FocusNode(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final title = titleController.text;
                  final content =
                      _controller.document.toPlainText(); // Quill 문서의 텍스트 가져오기
                  final contentJson = _controller.document.toDelta().toJson();

                  if (title.isNotEmpty && content.isNotEmpty) {
                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(title)
                        .set({
                      'title': title,
                      'text': content,
                      'content': contentJson,
                      'created_at': Timestamp.now(),
                    });
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('포스트가 업로드되었습니다!')),
                        );
                      },
                    );
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('제목과 내용을 모두 입력해주세요.')),
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
