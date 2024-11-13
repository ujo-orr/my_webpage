import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:my_webpage/data/provider/post_provider.dart';

class PostingPage extends ConsumerWidget {
  const PostingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController =
        ref.watch(postingViewModelProvider.notifier).titleController;
    final categoryController =
        ref.watch(postingViewModelProvider.notifier).categoryController;
    final editorController =
        ref.watch(postingViewModelProvider.notifier).editorController;

    return Scaffold(
      appBar: AppBar(
        title: const Text('POSTING PAGE'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.go('/'),
        ),
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
                    decoration: const InputDecoration(
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
                    decoration: const InputDecoration(
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
                    controller: editorController,
                    configurations: QuillSimpleToolbarConfigurations(
                      showAlignmentButtons: true,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () =>
                        ref.read(postingViewModelProvider.notifier).pickImage(),
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
                    controller: editorController,
                    configurations: QuillEditorConfigurations(
                        embedBuilders:
                            FlutterQuillEmbeds.defaultEditorBuilders()),
                    focusNode: FocusNode(),
                    scrollController: ScrollController(),
                    key: GlobalKey(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await ref
                        .read(postingViewModelProvider.notifier)
                        .uploadPost();
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('포스트가 업로드되었습니다!')),
                        );
                        context.go('/');
                      },
                    );
                  } catch (e) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('업로드 실패: $e')),
                        );
                      },
                    );
                  }
                },
                child: const Text('UPLOAD'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
