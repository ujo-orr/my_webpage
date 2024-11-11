import 'package:my_webpage/domain/usecase/fetch_sidebar_detail_usecase.dart';

class SidebarDetailViewModel {
  final FetchSidebarDetailUseCase fetchSidebarDetailUseCase;

  SidebarDetailViewModel(this.fetchSidebarDetailUseCase);

  String getSidebarDetail(String key) {
    return fetchSidebarDetailUseCase.execute(key);
  }
}
