import 'package:application_shoe_ecommerce/module/domain/entities/cart_item.dart';
import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/AddToCartUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/GetCartUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/RemoveFromCartUseCase.dart';
import 'package:application_shoe_ecommerce/module/domain/usecases/UpdateCartQuantityUseCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase getCartUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;

  CartCubit({
    required this.getCartUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.updateCartQuantityUseCase,
  }) : super(CartInitial());

  // Tải danh sách giỏ hàng
  Future<void> fetchCart(String userId) async {
    emit(CartLoading());
    try {
      final items = await getCartUseCase.execute(userId);
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  // Thêm vào giỏ hàng
  Future<void> addItemToCart({
    required String userId,
    required Shoe shoe,
    required String chosenColor,
    required int chosenSize,
    required int quantity,
  }) async {
    try {
      await addToCartUseCase.execute(
        userId: userId,
        shoe: shoe,
        selectedColor: chosenColor,
        selectedSize: chosenSize,
        quantity: quantity,
      );
      // Khi thêm mới từ màn hình Detail, fetch lại bình thường
      final items = await getCartUseCase.execute(userId);
      emit(CartLoaded(items));
    } catch (e) {
      emit(CartError("Thêm vào giỏ hàng thất bại: $e"));
    }
  }

  // Xóa khỏi giỏ hàng
  Future<void> removeItemFromCart(String userId, String cartItemId) async {
    if (state is CartLoaded) {
      final currentItems = (state as CartLoaded).cartItems;
      final updatedItems = currentItems
          .where((item) => item.id != cartItemId)
          .toList();
      emit(CartLoaded(updatedItems));
    }
    try {
      await removeFromCartUseCase.execute(userId, cartItemId);
    } catch (e) {
      final items = await getCartUseCase.execute(userId);
      emit(CartLoaded(items));
    }
  }

  // Thay đổi số lượng
  Future<void> changeQuantity(
    String userId,
    String cartItemId,
    int newQty,
  ) async {
    if (newQty < 1) return;

    if (state is CartLoaded) {
      final currentItems = (state as CartLoaded).cartItems;
      final updatedItems = currentItems.map((item) {
        if (item.id == cartItemId) {
          item.quantity = newQty;
        }
        return item;
      }).toList();
      emit(CartLoaded(updatedItems));
    }
    try {
      await updateCartQuantityUseCase.execute(userId, cartItemId, newQty);
    } catch (e) {
      final items = await getCartUseCase.execute(userId);
      emit(CartLoaded(items));
    }
  }
}
