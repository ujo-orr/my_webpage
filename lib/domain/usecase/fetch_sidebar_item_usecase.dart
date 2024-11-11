import 'package:my_webpage/data/repository/sidebar_repository.dart';

class FetchSidebarItemsUseCase {
  final SidebarRepository sidebarRepository;

  FetchSidebarItemsUseCase(this.sidebarRepository);

  List<String> execute() {
    return sidebarRepository.fetchSidebarItems();
  }
}
