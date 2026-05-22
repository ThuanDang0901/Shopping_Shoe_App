import 'package:application_shoe_ecommerce/module/domain/usecases/GetFeaturedShoesUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/SearchShoesUseCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'shoe_state.dart';

class ShoeCubit extends Cubit<ShoeState> {
  final GetFeaturedShoesUseCase getFeaturedShoesUseCase;
  final SearchShoesUseCase? searchShoesUseCase;

  ShoeCubit(this.getFeaturedShoesUseCase, {this.searchShoesUseCase})
    : super(ShoeInitial());

  Future<void> fetchFeaturedShoes() async {
    emit(ShoeLoading());
    try {
      final shoes = await getFeaturedShoesUseCase.execute();
      emit(ShoeLoaded(shoes));
    } catch (e) {
      emit(ShoeError("Lỗi tải sản phẩm nổi bật: ${e.toString()}"));
    }
  }

  //
  Future<void> searchProducts(String query) async {
    if (searchShoesUseCase == null) return;

    emit(ShoeLoading());
    try {
      final results = await searchShoesUseCase!.execute(query);
      emit(ShoeLoaded(results));
    } catch (e) {
      emit(ShoeError("Lỗi tìm kiếm sản phẩm: ${e.toString()}"));
    }
  }
}
