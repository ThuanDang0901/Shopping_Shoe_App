import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';
import 'package:application_shoe_ecommerce/module/domain/repositories/ShoeRepository.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetWishlistUseCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final GetWishlistUseCase getWishlistUseCase;
  final ShoeRepository shoeRepository;

  WishlistCubit({
    required this.getWishlistUseCase,
    required this.shoeRepository,
  }) : super(WishlistInitial());

  // Tải danh sách yêu thích
  Future<void> fetchWishlist(String userId) async {
    emit(WishlistLoading());
    try {
      final shoes = await getWishlistUseCase.execute(userId);
      emit(WishlistLoaded(shoes));
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  Future<void> checkFavoriteStatus(String userId, Shoe shoe) async {
    List<Shoe> currentList = [];
    if (state is WishlistLoaded) {
      currentList = (state as WishlistLoaded).favoriteShoes;
    } else if (state is WishlistOperationSuccess) {
      currentList = (state as WishlistOperationSuccess).favoriteShoes;
    }

    final isFav = await shoeRepository.checkIsFavorite(userId, shoe.id);
    shoe.isFavorite = isFav;
    emit(WishlistOperationSuccess(shoe.id, isFav, currentList));
  }

  Future<void> toggleWishlist(String userId, Shoe shoe) async {
    try {
      if (shoe.isFavorite) {
        await shoeRepository.removeFromWishlist(userId, shoe.id);
        shoe.isFavorite = false;
      } else {
        await shoeRepository.addToWishlist(userId, shoe);
        shoe.isFavorite = true;
      }
      final updatedShoes = await getWishlistUseCase.execute(userId);
      emit(WishlistLoaded(updatedShoes));
    } catch (e) {
      emit(WishlistError("Thao tác thất bại: $e"));
    }
  }
}
