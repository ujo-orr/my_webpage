import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_webpage/data/repository/sidebar_repository.dart';
import 'package:my_webpage/domain/usecase/fetch_sidebar_detail_usecase.dart';
import 'package:my_webpage/domain/usecase/fetch_sidebar_item_usecase.dart';
import 'package:my_webpage/presentation/viewmodel/sidebar_view_model.dart';

final sidebarRepositoryProvider = Provider((ref) => SidebarRepository(ref));

final sidebarDetailViewModelProvider = Provider<SidebarDetailViewModel>((ref) {
  final fetchSidebarDetailUseCase =
      ref.watch(fetchSidebarDetailUseCaseProvider);
  return SidebarDetailViewModel(fetchSidebarDetailUseCase);
});

final fetchSidebarDetailUseCaseProvider = Provider((ref) {
  final sidebarRepository = ref.watch(sidebarRepositoryProvider);
  return FetchSidebarDetailUseCase(sidebarRepository);
});

final sidebarViewModelProvider = Provider((ref) {
  final fetchSidebarItemsUseCase = ref.watch(fetchSidebarItemsUseCaseProvider);
  return SidebarViewModel(fetchSidebarItemsUseCase);
});

final fetchSidebarItemsUseCaseProvider = Provider((ref) {
  final sidebarRepository = ref.watch(sidebarRepositoryProvider);
  return FetchSidebarItemsUseCase(sidebarRepository);
});
