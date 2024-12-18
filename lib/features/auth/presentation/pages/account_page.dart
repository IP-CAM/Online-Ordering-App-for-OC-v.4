import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/config/routes/route_constants.dart';
import 'package:ordering_app/core/common/widgets/bottom_nav_bar.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ordering_app/features/auth/presentation/widgets/account_info_card.dart';
import 'package:ordering_app/features/theme/presentation/widgets/theme_mode_fab.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                      },
                      builder: (context, state) {
                        if (state is AuthInitialSuccess ||
                            state is AuthSuccess) {
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
                      context,
                      icon: Icons.lock_outline,
                      label: 'Change Password',
                      onTap: () {
                        // TODO: Implement change password navigation
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildActionButton(
                      context,
                      icon: Icons.location_on_outlined,
                      label: 'Address Book',
                      onTap: () {
                        // TODO: Implement address book navigation
                      },
                    ),

                    const SizedBox(height: 24),

                    // Logout Button
                    ElevatedButton.icon(
                      onPressed: () => _handleLogout(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red.shade400,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const ThemeModeFAB(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
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

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(LogoutEvent());
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
}
