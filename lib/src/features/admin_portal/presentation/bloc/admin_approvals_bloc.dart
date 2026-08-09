import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AdminApprovalsState extends Equatable {
  const AdminApprovalsState();
  @override
  List<Object?> get props => [];
}

class AdminApprovalsLoaded extends AdminApprovalsState {
  final List<Map<String, dynamic>> pending;
  final List<Map<String, dynamic>> active;
  final List<Map<String, dynamic>> suspended;

  const AdminApprovalsLoaded({
    required this.pending,
    required this.active,
    required this.suspended,
  });

  @override
  List<Object?> get props => [pending, active, suspended];
}

class AdminApprovalsBloc extends Cubit<AdminApprovalsState> {
  AdminApprovalsBloc()
      : super(const AdminApprovalsLoaded(
          pending: [
            {
              'id': 'v_101',
              'name': 'Sahiwal Karahi Point',
              'ownerName': 'Muhammad Hassan',
              'cnic': '36502-1234567-1',
              'address': 'Girls College Road, Sahiwal',
              'commissionRate': 15,
            },
          ],
          active: [
            {
              'id': 'v_102',
              'name': 'Royal Taj Restaurant & Bakers',
              'ownerName': 'Shaheed Ahmed',
              'cnic': '36502-9876543-9',
              'address': 'College Road, Sahiwal',
              'commissionRate': 12,
            },
          ],
          suspended: [],
        ));

  void approveVendor(String id) {
    emit(const AdminApprovalsLoaded(
      pending: [],
      active: [
        {
          'id': 'v_101',
          'name': 'Sahiwal Karahi Point',
          'ownerName': 'Muhammad Hassan',
          'cnic': '36502-1234567-1',
          'address': 'Girls College Road, Sahiwal',
          'commissionRate': 15,
        },
        {
          'id': 'v_102',
          'name': 'Royal Taj Restaurant & Bakers',
          'ownerName': 'Shaheed Ahmed',
          'cnic': '36502-9876543-9',
          'address': 'College Road, Sahiwal',
          'commissionRate': 12,
        },
      ],
      suspended: [],
    ));
  }

  void rejectVendor(String id) {
    emit(const AdminApprovalsLoaded(
      pending: [],
      active: [
        {
          'id': 'v_102',
          'name': 'Royal Taj Restaurant & Bakers',
          'ownerName': 'Shaheed Ahmed',
          'cnic': '36502-9876543-9',
          'address': 'College Road, Sahiwal',
          'commissionRate': 12,
        },
      ],
      suspended: [],
    ));
  }
}
