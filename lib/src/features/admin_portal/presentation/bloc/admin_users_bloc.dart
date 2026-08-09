import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AdminUsersState extends Equatable {
  const AdminUsersState();
  @override
  List<Object?> get props => [];
}

class AdminUsersLoaded extends AdminUsersState {
  final String activeRoleFilter;
  final List<Map<String, dynamic>> users;

  const AdminUsersLoaded({
    required this.activeRoleFilter,
    required this.users,
  });

  @override
  List<Object?> get props => [activeRoleFilter, users];
}

class AdminUsersBloc extends Cubit<AdminUsersState> {
  AdminUsersBloc()
      : super(const AdminUsersLoaded(
          activeRoleFilter: 'All',
          users: [
            {
              'id': 'usr_1',
              'name': 'Usman Raza',
              'contact': 'usman.sahiwal@gmail.com',
              'role': 'Customer',
              'status': 'Active',
              'regDate': '12 Jan 2026',
            },
            {
              'id': 'usr_2',
              'name': 'Royal Taj Owners',
              'contact': 'owner@royaltaj.com',
              'role': 'Owner',
              'status': 'Active',
              'regDate': '05 Feb 2026',
            },
            {
              'id': 'usr_3',
              'name': 'Tariq Rider',
              'contact': '+92 300 8887766',
              'role': 'Rider',
              'status': 'Active',
              'regDate': '20 Feb 2026',
            },
            {
              'id': 'usr_4',
              'name': 'Spam User Account',
              'contact': 'spam@gmail.com',
              'role': 'Customer',
              'status': 'Blocked',
              'regDate': '01 Mar 2026',
            },
          ],
        ));

  void toggleBlockUser(String userId) {
    if (state is AdminUsersLoaded) {
      final current = state as AdminUsersLoaded;
      final updated = current.users.map((u) {
        if (u['id'] == userId) {
          final isBlocked = u['status'] == 'Blocked';
          return {...u, 'status': isBlocked ? 'Active' : 'Blocked'};
        }
        return u;
      }).toList();
      emit(AdminUsersLoaded(
        activeRoleFilter: current.activeRoleFilter,
        users: updated,
      ));
    }
  }

  void setRoleFilter(String role) {
    if (state is AdminUsersLoaded) {
      final current = state as AdminUsersLoaded;
      emit(AdminUsersLoaded(
        activeRoleFilter: role,
        users: current.users,
      ));
    }
  }
}
