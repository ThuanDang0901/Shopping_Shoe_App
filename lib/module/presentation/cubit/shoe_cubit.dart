import 'package:application_shoe_ecommerce/module/domain/usecases/GetFeaturedShoesUseCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'shoe_state.dart';

class ShoeCubit extends Cubit<ShoeState> {
  final GetFeaturedShoesUseCase getFeaturedShoesUseCase;

  ShoeCubit(this.getFeaturedShoesUseCase) : super(ShoeInitial());

  Future<void> fetchFeaturedShoes() async {
    emit(ShoeLoading());
    try {
      final shoes = await getFeaturedShoesUseCase.execute();
      emit(ShoeLoaded(shoes));
    } catch (e) {
      emit(ShoeError("Lỗi tải sản phẩm nổi bật: ${e.toString()}"));
    }
  }
}
