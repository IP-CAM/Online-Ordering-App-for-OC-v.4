import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/config/routes/route_constants.dart';
import 'package:ordering_app/core/utils/form_dialog.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ordering_app/features/auth/presentation/widgets/account_info_card.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late AuthBloc _authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Store reference to BlocProvider
    _authBloc = context.read<AuthBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Custom App Bar with gradient
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primaryContainer,
                  ],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // User Information Card
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthFailure) {
                        showCustomSnackBar(
                          context: context,
                          message: state.error,
                          type: SnackBarType.error,
                        );
                      }
                      if (state is AuthLoading) {
                        Loader.show(context);
                      } else {
                        Loader.hide();
                      }

                      if (state is AuthLogoutSuccess) {
                        NavigationService.pushReplacement(
                          context,
                          RouteConstants.login,
                        );
                      }

                      if (state is AccountDeleteSuccess) {
                        showCustomSnackBar(
                            context: context,
                            message: state.message,
                            type: SnackBarType.success);
                        BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                      }
                      if (state is ResetPasswordSuccess) {
                        showCustomSnackBar(
                            context: context,
                            message: state.message,
                            type: SnackBarType.success);
                        BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthInitialSuccess || state is AuthSuccess) {
                        final userInfo = state is AuthInitialSuccess
                            ? state.loginInfoEntity
                            : (state as AuthSuccess).loginInfoEntity;
                        return AccountInfoCard(userInfo: userInfo);
                      }
                      return const SizedBox();
                    },
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  _buildActionButton(
                    icon: Icons.lock_outline,
                    label: 'Change Password',
                    onTap: _handleResetPassword,
                  ),

                  const SizedBox(height: 12),

                  _buildActionButton(
                    icon: Icons.location_on_outlined,
                    label: 'Address Book',
                    onTap: () =>NavigationService.push(context, RouteConstants.addressBook,),
                  ),
                  const SizedBox(height: 12),

                  _buildActionButton(
                    icon: Icons.logout,
                    label: 'Logout',
                    onTap: _handleLogout,
                  ),
                  const SizedBox(height: 12),

                  _buildActionButton(
                    icon: Icons.delete_forever_outlined,
                    label: 'Delete account',
                    onTap: _handleDeleteAcc,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _authBloc.add(LogoutEvent());
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleDeleteAcc() {
    void onPasswordConfirmed(String password) {
      _authBloc.add(DeleteAccountEvent(password: password));
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Confirm Delete Account'),
          content: const Text('Are you sure you want to delete account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                FormDialog.show(
                  context: context,
                  title: 'Confirm Password',
                  submitButtonText: 'Delete',
                  fields: const [
                    DynamicFormField(
                      label: 'Password',
                      isObscure: true,
                      isRequired: true,
                      key: 'password',
                    ),
                  ],
                  onConfirm: (results) {
                    onPasswordConfirmed(results['password'] ?? '');
                  },
                );
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleResetPassword() {
    void onPasswordConfirmed(String password, String confirm) {
      debugPrint('Password: $password \nConfirm: $confirm');
      _authBloc.add(
        ResetPasswordEvent(
          password: password,
          confirm: confirm,
        ),
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Confirm Reset Password'),
          content: const Text('Are you sure you want to reset password?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                FormDialog.show(
                  context: context,
                  title: 'Reset Password',
                  submitButtonText: 'Reset',
                  fields: const [
                    DynamicFormField(
                      label: 'New password',
                      isObscure: true,
                      isRequired: true,
                      key: 'password',
                      validationRules: ValidationRules(
                        min: 5,
                      ),
                    ),
                    DynamicFormField(
                      label: 'Confirm password',
                      isObscure: true,
                      isRequired: true,
                      key: 'confirm',
                      validationRules: ValidationRules(
                        min: 5,
                      ),
                    ),
                  ],
                  onConfirm: (results) {
                    onPasswordConfirmed(
                        results['password'] ?? '', results['confirm'] ?? '');
                  },
                );
              },
              child: const Text(
                'Reset',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
