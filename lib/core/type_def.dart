import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';

///FutureEither is a type that returns a Future<Either<Failure, T>>
///where T is the type of data we want to return
///and Failure is the type of error we want to return
///this is a generic type
typedef FutureEither<T> = Future<Either<Failure, T>>;

///FutureVoid is a type that returns a Future<void>
///this is a generic type
typedef FutureVoid = FutureEither<void>;
