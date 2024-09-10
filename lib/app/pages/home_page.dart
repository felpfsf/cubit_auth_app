import 'package:cubit_auth_app/app/core/auth_cubit/auth_cubit.dart';
import 'package:cubit_auth_app/app/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit Pulse'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            unauthenticated: () =>
                Navigator.of(context).pushReplacementNamed('/login'),
            orElse: () {},
          );
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final username = state.maybeWhen(
              authenticated: (user) => user.displayName,
              orElse: () => null,
            );
            return Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bem vindo $username'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                      },
                      child: const Text('Logout'),
                    ),
                    CustomLoader<AuthCubit, AuthState>(
                      selector: (state) {
                        return state.maybeWhen(
                          loading: () => true,
                          orElse: () => false,
                        );
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
