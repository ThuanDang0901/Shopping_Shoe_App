import 'dart:io';

import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetFeaturedShoesUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/SearchShoesUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/admin/AddProductUseCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'shoe_state.dart';

class ShoeCubit extends Cubit<ShoeState> {
  final GetFeaturedShoesUseCase getFeaturedShoesUseCase;
  final SearchShoesUseCase? searchShoesUseCase;
  final AddProductUseCase? addProductUseCase;

  ShoeCubit(
    this.getFeaturedShoesUseCase, {
    this.searchShoesUseCase,
    this.addProductUseCase,
  }) : super(ShoeInitial());

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

  Future<void> addNewProduct({
    required String name,
    required String sku,
    required String description,
    required double price,
    required int stockQuantity,
    required String category,
    required List<String> colors,
    required List<int> sizes,
    required File imageFile,
  }) async {
    if (addProductUseCase == null) return;

    emit(ShoeLoading());

    try {
      const String hardcodedImageUrl = "assets/img/product/6.png";

      final newShoe = Shoe(
        id: '',
        name: name,
        sku: sku,
        description: description,
        price: price,
        image: hardcodedImageUrl,
        stockQuantity: stockQuantity,
        soldCount: 0,
        category: category,
        isActive: true,
        colors: colors,
        sizes: sizes,
      );

      await addProductUseCase!.execute(newShoe);
      await fetchFeaturedShoes();
    } catch (e) {
      emit(ShoeError("Lỗi khi thêm sản phẩm: ${e.toString()}"));
    }
  }
}
