import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? avatar;

  const User({
    required this.id,
    this.name,
    this.email,
    this.avatar,
  });

  static const empty = User(id: '');

  bool get isEmpty => this == User.empty;

  @override
  List<Object?> get props => [id, name, email, avatar];
}
