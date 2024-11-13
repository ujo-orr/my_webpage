import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_webpage/data/provider/sidebar_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SidebarPage extends ConsumerWidget {
  final String detailKey;

  const SidebarPage({super.key, required this.detailKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(sidebarDetailViewModelProvider);
    final detailValue = viewModel.getSidebarDetail(detailKey);

    return Scaffold(
      appBar: AppBar(
        title: Text(detailKey),
        leading: IconButton(
          onPressed: () {
            context.go('/');
          },
          icon: const Icon(Icons.home),
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () async {
            if (Uri.tryParse(detailValue)?.hasAbsolutePath == true) {
              final Uri url = Uri.parse(detailValue);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('URL을 열 수 없습니다: $detailValue')),
                    );
                  },
                );
              }
            }
          },
          child: Text(
            detailValue,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Uri.tryParse(detailValue)?.hasAbsolutePath == true
                  ? Colors.blue
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
