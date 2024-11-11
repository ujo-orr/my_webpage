import 'package:my_webpage/data/repository/sidebar_repository.dart';

class FetchSidebarDetailUseCase {
  final SidebarRepository sidebarRepository;

  FetchSidebarDetailUseCase(this.sidebarRepository);

  String execute(String key) {
    return sidebarRepository.fetchSidebarDetail(key);
  }
}
