import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hipstarvideocall/pages/user_list/user_list_screen.dart';
import 'package:provider/provider.dart';
import 'package:hipstarvideocall/bloc/login/login_screen_event.dart';
import 'package:hipstarvideocall/bloc/login/login_screen_state.dart';
import 'package:hipstarvideocall/utils/colors.dart';
import 'package:hipstarvideocall/utils/text_styles.dart';
import 'package:hipstarvideocall/bloc/login/login_screen_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

  // Add controllers with default ReqRes credentials
  final TextEditingController _emailController =
  TextEditingController(text: 'eve.holt@reqres.in');
  final TextEditingController _passwordController =
  TextEditingController(text: 'cityslicka');

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<LoginBloc>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 120),
              const SizedBox(height: 16),
              Text('Welcome to Meetify', style: AppTextStyles.largeBold),
              const SizedBox(height: 4),
              Text(
                'Connecting world',
                style: AppTextStyles.mediumBold.copyWith(color: AppColors.textPrimary),
              ),
              const SizedBox(height: 32),

              BlocListener<LoginBloc, LoginState>(
                bloc: bloc,
                listener: (context, state) {
                  if (state.isSuccess) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const UserListScreen()),
                    );
                  }
                },
                child: BlocBuilder<LoginBloc, LoginState>(
                  bloc: bloc,
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email Field
                        Text('Email', style: AppTextStyles.mediumBold),
                        const SizedBox(height: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: state.error.toLowerCase().contains('email')
                                  ? AppColors.error
                                  : AppColors.textSecondary,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _emailController,
                            onChanged: (value) => bloc.add(EmailChanged(value)),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter email address',
                              hintStyle: AppTextStyles.smallHint,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        Text('Password', style: AppTextStyles.mediumBold),
                        const SizedBox(height: 8),
                        ValueListenableBuilder<bool>(
                          valueListenable: _obscurePassword,
                          builder: (context, obscure, _) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: state.error.toLowerCase().contains('password')
                                      ? AppColors.error
                                      : AppColors.textSecondary,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _passwordController,
                                      onChanged: (value) => bloc.add(PasswordChanged(value)),
                                      obscureText: obscure,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Enter Password',
                                        hintStyle: AppTextStyles.smallHint,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      obscure ? Icons.visibility : Icons.visibility_off,
                                      color: AppColors.textSecondary,
                                    ),
                                    onPressed: () {
                                      _obscurePassword.value = !_obscurePassword.value;
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Error message
                        if (state.error.isNotEmpty)
                          Text(state.error, style: AppTextStyles.smallError),
                        if (state.isSubmitting) ...[
                          const SizedBox(height: 16),
                          const Center(
                            child: CircularProgressIndicator(color: AppColors.purple),
                          ),
                        ],

                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.btnColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: state.isSubmitting
                                ? null
                                : () {
                              bloc.add(EmailChanged(_emailController.text));
                              bloc.add(PasswordChanged(_passwordController.text));
                              bloc.add(LoginSubmitted());
                            },
                            child: Text(
                              'Login',
                              style: AppTextStyles.mediumBold.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
