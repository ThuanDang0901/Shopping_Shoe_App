import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetAllCategoryUseCase.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetAllCategoryUseCase getAllCategoryUseCase;

  CategoryCubit(this.getAllCategoryUseCase) : super(CategoryInitial());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await getAllCategoryUseCase.execute();
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError("Không thể tải danh mục: $e"));
    }
  }
}
