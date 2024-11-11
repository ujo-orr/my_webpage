import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_webpage/domain/usecase/pick_image_usecase.dart';
import 'package:my_webpage/domain/usecase/upload_post_usecase.dart';
import 'package:my_webpage/shared/utility/image_converter.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class PostingViewModel extends StateNotifier<AsyncValue<void>> {
  final UploadPostUseCase uploadPostUseCase;
  final PickImageUseCase pickImageUseCase;
  final QuillController editorController;
  final TextEditingController titleController;
  final TextEditingController categoryController;

  PostingViewModel(
    this.uploadPostUseCase,
    this.pickImageUseCase,
    this.editorController,
    this.titleController,
    this.categoryController,
  ) : super(const AsyncValue.data(null));

  // 이미지 선택 로직
  Future<void> pickImage() async {
    final Uint8List? imageData = await pickImageUseCase.execute();
    if (imageData != null) {
      final imageUrl = ImageConverter.convertToBase64(imageData);
      final index = editorController.selection.baseOffset;
      editorController.document.insert(index, BlockEmbed.image(imageUrl));
      editorController.updateSelection(
        TextSelection.collapsed(offset: index + 1),
        ChangeSource.local,
      );
    }
  }

  // 게시물 업로드 로직
  Future<void> uploadPost() async {
    if (titleController.text.isEmpty || categoryController.text.isEmpty) {
      throw Exception('Title and category are required.');
    }

    final List<Map<String, dynamic>> contentDelta =
        editorController.document.toDelta().toJson();
    final converter = QuillDeltaToHtmlConverter(contentDelta);
    final contentHtml = converter.convert();

    state = const AsyncValue.loading();
    try {
      await uploadPostUseCase.execute(
        titleController.text,
        categoryController.text,
        contentHtml,
      );
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}
