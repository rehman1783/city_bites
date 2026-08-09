import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String avatarUrl;

  const ProfileLoaded({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, email, phone, address, avatarUrl];
}

class ProfileBloc extends Cubit<ProfileState> {
  ProfileBloc()
      : super(const ProfileLoaded(
          name: 'Shaheed Ahmed',
          email: 'shaheed.sahiwal@gmail.com',
          phone: '+92 300 1234567',
          address: 'House 42, Scheme 3, College Road, Sahiwal',
          avatarUrl:
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400&auto=format&fit=crop&q=60',
        ));
}
