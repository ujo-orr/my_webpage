import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sidebardata.dart';

class SidebarPage extends ConsumerWidget {
  const SidebarPage({super.key, required this.detailKey});
  final String detailKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sideBarDetails = ref.watch(sideBarDetailsProvider);
    final detailValue = sideBarDetails[detailKey] ?? '정보가 없습니다';

    return Scaffold(
      appBar: AppBar(
        title: Text(detailKey),
        leading: IconButton(
          onPressed: () {
            context.go('/');
          },
          icon: Icon(Icons.home),
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () async {
            // detailValue가 링크일 경우 브라우저로 열기
            if (Uri.tryParse(detailValue)?.hasAbsolutePath == true) {
              final Uri url = Uri.parse(detailValue);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('URL을 열 수 없습니다: $detailValue')),
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
                  ? Colors.blue // 링크일 경우 파란색 텍스트
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
