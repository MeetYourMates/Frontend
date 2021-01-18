class Helper {
  static T tryCast<T>(dynamic x, {T fallback}) {
    try {
      return (x as T);
    } on TypeError catch (e) {
      print('CastError $e --> when trying to cast $x to $T!');
      return fallback;
    }
  }
}
