import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromRGBO(44, 62, 80, 0.9),
                  Color.fromRGBO(0, 0, 0, 0.75),
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 440),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_add_alt_1,
                          size: 65,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Buat Akun',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppColors.secondary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Bergabung dengan Incitrack',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 35),
                        
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(hintText: 'Nama Lengkap'),
                        ),
                        const SizedBox(height: 20),
                        
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(hintText: 'Email'),
                        ),
                        const SizedBox(height: 20),
                        
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(hintText: 'Password'),
                        ),
                        const SizedBox(height: 20),
                        
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: const InputDecoration(hintText: 'Konfirmasi Password'),
                        ),
                        const SizedBox(height: 30),
                        
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : () async {
                                    String name = _nameController.text.trim();
                                    String email = _emailController.text.trim();
                                    String password = _passwordController.text.trim();
                                    String confirmPassword = _confirmPasswordController.text.trim();

                                    if (name.isEmpty || email.isEmpty || password.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Semua field wajib diisi!')),
                                      );
                                      return;
                                    }

                                    if (password != confirmPassword) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Konfirmasi password tidak cocok!')),
                                      );
                                      return;
                                    }

                                    final success = await authProvider.register(name, email, password);

                                    if (success) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Pendaftaran berhasil! Silakan masuk.')),
                                        );
                                        Navigator.pop(context); // Kembali ke Login
                                      }
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(authProvider.errorMessage ?? 'Pendaftaran Gagal!')),
                                        );
                                      }
                                    }
                                  },
                            child: authProvider.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text('Daftar Sekarang'),
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Sudah punya akun? ',
                              style: TextStyle(color: AppColors.textLight, fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context); // Go back to login
                              },
                              child: const Text(
                                'Masuk',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
