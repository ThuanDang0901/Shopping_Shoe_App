import 'package:application_shoe_ecommerce/module/domain/entities/shoe.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<Shoe> favoriteShoes;
  WishlistLoaded(this.favoriteShoes);
}

class WishlistOperationSuccess extends WishlistState {
  final String shoeId;
  final bool isFavorite;
  final List<Shoe> favoriteShoes;

  WishlistOperationSuccess(this.shoeId, this.isFavorite, this.favoriteShoes);
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}
