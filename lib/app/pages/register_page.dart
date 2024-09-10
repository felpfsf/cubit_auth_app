import 'package:cubit_auth_app/app/core/auth_cubit/auth_cubit.dart';
import 'package:cubit_auth_app/app/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameEC = TextEditingController();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            authenticated: (user) =>
                Navigator.of(context).pushReplacementNamed('/home'),
            error: (message) {
              return ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Registrar',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nameEC,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira um nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailEC,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira um email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  obscureText: true,
                  controller: _passwordEC,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Insira uma senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final email = _emailEC.text.trim();
                        final password = _passwordEC.text.trim();
                        final name = _nameEC.text.trim();
                        context
                            .read<AuthCubit>()
                            .register(email, password, name);
                      }
                    },
                    child: const Text('Cadastrar'),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Já tem conta?'),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => Navigator.of(context).pushNamed('/login'),
                      child: const Text(
                        'Entre aqui',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
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
        ),
      ),
    );
  }
}
