import 'package:my_webpage/domain/usecase/fetch_sidebar_item_usecase.dart';

class SidebarViewModel {
  final FetchSidebarItemsUseCase fetchSidebarItemsUseCase;

  SidebarViewModel(this.fetchSidebarItemsUseCase);

  List<String> getSidebarItems() {
    return fetchSidebarItemsUseCase.execute();
  }
}
