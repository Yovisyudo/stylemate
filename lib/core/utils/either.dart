
abstract class Either<L, R> {
  const Either();
  
  T fold<T>(T Function(L) leftFn, T Function(R) rightFn);
  
  bool isLeft();
  bool isRight();
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);
  
  @override
  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) => leftFn(value);
  
  @override
  bool isLeft() => true;
  
  @override
  bool isRight() => false;
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);
  
  @override
  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) => rightFn(value);
  
  @override
  bool isLeft() => false;
  
  @override
  bool isRight() => true;
}
