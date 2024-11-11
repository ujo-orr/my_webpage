import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../sidebardata.dart';

class SidebarRepository {
  final Ref ref;

  SidebarRepository(this.ref);

  List<String> fetchSidebarItems() {
    return ref.read(sideBarProvider);
  }

  String fetchSidebarDetail(String key) {
    final details = ref.read(sideBarDetailsProvider);
    return details[key] ?? '정보가 없습니다';
  }
}
