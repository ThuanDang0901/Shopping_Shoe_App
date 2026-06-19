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

    Future<void> fetchCart(String userId) async {
      emit(CartLoading());
      try {
        final items = await getCartUseCase.execute(userId);
        emit(CartLoaded(items));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    }

    Future<void> addToCart({
      required String userId,
      required Shoe shoe,
      required String variantId,
      required int selectedSize,
      required String selectedColor,
      required int quantity,
    }) async {
      emit(CartLoading());
      try {
        final finalVariantId = variantId.isEmpty
            ? "${shoe.id}_${selectedColor}_$selectedSize"
            : variantId;

        final newItem = CartItem(
          id: '',
          shoe: shoe,
          variantId: finalVariantId,
          selectedSize: selectedSize,
          selectedColor: selectedColor,
          quantity: quantity,
        );

        await addToCartUseCase.execute(userId, newItem);
        await fetchCart(userId);
      } catch (e) {
        emit(CartError(e.toString()));
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

    Future<void> changeQuantity(
      String userId,
      String cartItemId,
      int newQty,
    ) async {
      if (newQty < 1) return;

      try {
        await updateCartQuantityUseCase.execute(userId, cartItemId, newQty);

        if (state is CartLoaded) {
          final currentItems = (state as CartLoaded).cartItems;

          final updatedItems = currentItems.map((item) {
            if (item.id == cartItemId) {
              return item.copyWith(quantity: newQty);
            }
            return item;
          }).toList();

          emit(CartLoaded(updatedItems));
        }
      } catch (e) {
        final items = await getCartUseCase.execute(userId);
        emit(CartLoaded(items));
      }
    }
  }
