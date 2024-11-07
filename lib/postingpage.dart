import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'data/postdata.dart';

class PostingPage extends ConsumerStatefulWidget {
  const PostingPage({super.key});

  @override
  ConsumerState<PostingPage> createState() => _PostingPageState();
}

class _PostingPageState extends ConsumerState<PostingPage> {
  final QuillController _controller = QuillController.basic();
  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final BlogService _blogService = BlogService();

  Future<void> pickImage() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final Uint8List imageData = await pickedFile.readAsBytes();
        final String base64Image = base64Encode(imageData);

        final imageUrl = 'data:image/png;base64,$base64Image';
        final index = _controller.selection.baseOffset;
        _controller.document.insert(index, BlockEmbed.image(imageUrl));
        _controller.updateSelection(
          TextSelection.collapsed(offset: index + 1),
          ChangeSource.local,
        );
      }
    } catch (e) {
      throw Exception('pickImage error : $e');
    }
  }

  Future<void> uploadPosts() async {
    try {
      final String title = titleController.text;
      final String category = categoryController.text;

      // Delta 객체를 HTML 형식으로 변환
      final List<Map<String, dynamic>> contentDelta =
          _controller.document.toDelta().toJson();
      final converter = QuillDeltaToHtmlConverter(contentDelta);
      final contentHtml = converter.convert();

      if (title.isEmpty || category.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('제목과 카테고리를 모두 입력해주세요.')),
          );
        }
        return;
      }

      // 이미지 선택 및 인코딩
      final picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      String? base64Image;
      if (pickedFile != null) {
        final Uint8List imageData = await pickedFile.readAsBytes();
        base64Image = base64Encode(imageData);
      }

      await _blogService.uploadPost(
        title: title,
        category: category,
        quillContentHtml: contentHtml,
        base64Image: base64Image, // 인코딩된 이미지가 있으면 전달
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('포스트가 업로드되었습니다!')),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('업로드 중 오류가 발생했습니다. 다시 시도해주세요.')),
        );
      }
    }
  }

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
                  QuillToolbar.simple(
                    controller: _controller,
                    configurations: QuillSimpleToolbarConfigurations(
                        toolbarIconAlignment: WrapAlignment.center,
                        showAlignmentButtons: true),
                  ),
                  IconButton(
                    icon: Icon(Icons.image),
                    onPressed: pickImage,
                  ),
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
                      embedBuilders: FlutterQuillEmbeds.defaultEditorBuilders(),
                    ),
                    focusNode: FocusNode(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: uploadPosts,
                child: Text('UPLOAD'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
