import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'data/postdata.dart';

class PostingPage extends ConsumerStatefulWidget {
  const PostingPage({super.key});

  @override
  ConsumerState<PostingPage> createState() => _PostingPageState();
}

class _PostingPageState extends ConsumerState<PostingPage> {
  final QuillController _controller = QuillController(
    document: Document(),
    selection: TextSelection.collapsed(offset: 0),
  );
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final BlogService _blogService = BlogService();

  String? imageUrl;
  String? videoUrl;

  // Firebase Storage에 업로드된 이미지 URL을 가져와 QuillEditor에 추가
  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List imageData = await pickedFile.readAsBytes();

      // Firebase Storage에 이미지 업로드 후 URL 받기
      final uploadedImageUrl = await _blogService.uploadImageToStorage(
        imageData: imageData,
        fileName: pickedFile.name,
      );

      if (uploadedImageUrl != null) {
        // QuillEditor에 Firebase Storage의 이미지 URL 추가
        final index = _controller.selection.baseOffset;
        _controller.document.insert(index, BlockEmbed.image(uploadedImageUrl));
        _controller.updateSelection(
          TextSelection.collapsed(offset: index + 1),
          ChangeSource.local,
        );
      }
    }
  }

  Future<dynamic> pickAndUploadVideo() async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List videoData = await pickedFile.readAsBytes();

      // Firebase Storage에 비디오 업로드 후 URL 받기
      videoUrl = await _blogService.uploadVideoToStorage(
        videoData: videoData,
        fileName: pickedFile.name,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('POSTING PAGE'),
        leading: IconButton(
            onPressed: () {
              context.go('/');
            },
            icon: Icon(Icons.home)),
      ),
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
                  QuillSimpleToolbar(
                    controller: _controller,
                    configurations: QuillSimpleToolbarConfigurations(
                      showAlignmentButtons: true,
                    ),
                  ),
                  QuillToolbarImageButton(
                    controller: _controller,
                    options: QuillToolbarImageButtonOptions(),
                  ),
                  QuillToolbarVideoButton(
                    controller: _controller,
                    options: QuillToolbarVideoButtonOptions(),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 600,
                  height: 600,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white)),
                  child: QuillEditor(
                    controller: _controller,
                    scrollController: ScrollController(),
                    configurations: QuillEditorConfigurations(
                        embedBuilders:
                            FlutterQuillEmbeds.defaultEditorBuilders()),
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
                      quillContent: contentJson,
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('제목과 카테고리를 모두 입력해주세요.')),
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
