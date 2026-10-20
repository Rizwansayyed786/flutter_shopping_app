import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/primary_button.dart';
import '../bloc/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.products);
        } else if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.errorMessage ?? 'Login failed'),
              backgroundColor: theme.colorScheme.error,
            ));
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.shopping_bag_rounded,
                          color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Welcome back 👋',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue shopping on ${AppConstants.appName}.',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 32),
                    const _EmailField(),
                    const SizedBox(height: 16),
                    const _PasswordField(),
                    const SizedBox(height: 24),
                    const _LoginButton(),
                    const SizedBox(height: 24),
                    const _DemoCredentialsHint(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (p, c) => p.emailError != c.emailError,
      builder: (context, state) {
        return TextField(
          key: const Key('login_email_field'),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          onChanged: (v) => context.read<LoginBloc>().add(EmailChanged(v)),
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'you@example.com',
            prefixIcon: const Icon(Icons.email_outlined),
            errorText: state.emailError,
          ),
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (p, c) =>
          p.passwordError != c.passwordError ||
          p.obscurePassword != c.obscurePassword,
      builder: (context, state) {
        return TextField(
          key: const Key('login_password_field'),
          obscureText: state.obscurePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          onChanged: (v) => context.read<LoginBloc>().add(PasswordChanged(v)),
          onSubmitted: (_) {
            final bloc = context.read<LoginBloc>();
            if (bloc.state.isValid) bloc.add(const LoginSubmitted());
          },
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            errorText: state.passwordError,
            suffixIcon: IconButton(
              tooltip:
                  state.obscurePassword ? 'Show password' : 'Hide password',
              icon: Icon(state.obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined),
              onPressed: () => context
                  .read<LoginBloc>()
                  .add(const TogglePasswordVisibility()),
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (p, c) => p.isValid != c.isValid || p.status != c.status,
      builder: (context, state) {
        return PrimaryButton(
          label: 'Login',
          isLoading: state.isSubmitting,
          // null => button disabled until both inputs are valid
          onPressed: state.isValid
              ? () => context.read<LoginBloc>().add(const LoginSubmitted())
              : null,
        );
      },
    );
  }
}

class _DemoCredentialsHint extends StatelessWidget {
  const _DemoCredentialsHint();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text('Demo credentials',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary)),
            ],
          ),
          const SizedBox(height: 8),
          const SelectableText('Email: ${AppConstants.dummyEmail}'),
          const SelectableText('Password: ${AppConstants.dummyPassword}'),
        ],
      ),
    );
  }
}
