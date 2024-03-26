// import 'package:job/src/features/auth/providers/auth_state.dart';
// import 'package:riverpod/riverpod.dart';

// final authProvider = StateNotifierProvider<AuthProvider, AuthState>(
//   (ref) => AuthProvider(),
// );

// class AuthProvider extends StateNotifier<AuthState> {
//   AuthProvider() : super(const AuthState());

//   Future<void> getUserList() async {
//     try {
//       state = state.copyWith(isUserListLoading: true);
//       final response = await _repo.getUserList();

//       if (response != null) {
//         state = state.copyWith(userList: response.data);
//       }
//     } catch (e, s) {
//       Log.e(s, e);
//     } finally {
//       state = state.copyWith(isUserListLoading: false);
//     }
//   }
// }
