import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/locale_cubit.dart';
import '/l10n/app_localizations.dart';
import '../models/user_hive_model.dart';
import 'ai_assistant.dart';

final GetIt getIt = GetIt.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _buttonsController;
  late Animation<double> _titleAnimation;
  late Animation<double> _buttonsAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showLanguageDialog = true;
  final _userBox = Hive.box<UserHive>('userBox');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isLoading = false;
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _canCheckBiometrics = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _focusNodeEmail = FocusNode();
  final _focusNodePassword = FocusNode();

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      _canCheckBiometrics = await _localAuth.canCheckBiometrics;
    } catch (e) {
      _canCheckBiometrics = false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _titleController.dispose();
    _buttonsController.dispose();
    super.dispose();
  }

  void _initAnimations() {
    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _buttonsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _titleAnimation = CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeInOutBack,
    );

    _buttonsAnimation = CurvedAnimation(
      parent: _buttonsController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _buttonsController,
      curve: Curves.easeOutQuart,
    ));

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _titleController.forward();
      _buttonsController.forward();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await _signInWithEmail();
      } else {
        await _registerWithEmail();
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        await _handleLoginSuccess(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'Google User',
          email: userCredential.user!.email ?? '',
          photoUrl: userCredential.user!.photoURL,
          loginMethod: 'google',
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google sign in failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (!_canCheckBiometrics) return;

    try {
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        await _handleGuestLogin();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Biometric authentication failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _signInWithEmail() async {
    final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (userCredential.user != null) {
      await _handleLoginSuccess(
        id: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? _emailController.text.split('@').first,
        email: userCredential.user!.email ?? _emailController.text.trim(),
        photoUrl: userCredential.user!.photoURL,
        loginMethod: 'email',
      );
    }
  }

  Future<void> _registerWithEmail() async {
    final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (userCredential.user != null) {
      await userCredential.user!.updateDisplayName(_emailController.text.split('@').first);
      await _handleLoginSuccess(
        id: userCredential.user!.uid,
        name: _emailController.text.split('@').first,
        email: _emailController.text.trim(),
        photoUrl: userCredential.user!.photoURL,
        loginMethod: 'email',
      );
    }
  }

  Future<void> _handleGuestLogin() async {
    setState(() => _isLoading = true);
    try {
      final UserCredential userCredential = await _auth.signInAnonymously();
      final User? user = userCredential.user;
      
      if (user != null) {
        await _handleLoginSuccess(
          id: user.uid,
          name: 'Guest User',
          email: 'guest@example.com',
          loginMethod: 'anonymous',
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Guest login failed: ${e.message}')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Guest login failed: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _handleLoginSuccess({
    required String id,
    required String name,
    required String email,
    String? photoUrl,
    required String loginMethod,
  }) async {
    try {
      final user = UserHive(
        id: id,
        name: name,
        email: email,
        photoUrl: photoUrl,
        loginMethod: loginMethod,
      );

      await _userBox.put('currentUser', user);

      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/home');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save user data: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address'),
        ),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent. Please check your inbox.'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tr = AppLocalizations.of(context)!;
    final isDarkMode = theme.brightness == Brightness.dark;

    if (_showLanguageDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLanguageSelection(context);
        setState(() => _showLanguageDialog = false);
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDarkMode
                    ? [
                        Colors.black,
                        Colors.blueGrey.shade900,
                        Colors.black,
                      ]
                    : [
                        Colors.blue.shade100,
                        Colors.white,
                        Colors.blue.shade100,
                      ],
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScaleTransition(
                    scale: _titleAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr.welcome_to,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tr.app_name,
                          style: GoogleFonts.montserrat(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeTransition(
                    opacity: _buttonsAnimation,
                    child: Text(
                      tr.login_quote,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _buttonsAnimation,
                      child: _buildLoginForm(context, theme, tr),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _buttonsAnimation,
                    child: _buildSocialLoginButtons(context, theme),
                  ),
                  const SizedBox(height: 24),
                  FadeTransition(
                    opacity: _buttonsAnimation,
                    child: _buildFooter(context, theme, tr),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, ThemeData theme, AppLocalizations tr) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              focusNode: _focusNodeEmail,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                _focusNodePassword.requestFocus();
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              focusNode: _focusNodePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    if (_isLogin)
                      TextButton(
                        onPressed: _handleForgotPassword,
                        child: Text(
                          'Forgot?',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                _submit();
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 5,
              ),
              child: Text(
                _isLogin ? 'Login' : 'Register',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLogin
                      ? 'Don\'t have an account?'
                      : 'Already have an account?',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 4),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(
                    _isLogin ? 'Register' : 'Login',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // if (_canCheckBiometrics)
            //   Center(
            //     child: TextButton.icon(
            //       onPressed: _authenticateWithBiometrics,
            //       icon: const Icon(Icons.fingerprint),
            //       label: Text(
            //         'Use Biometrics',
            //         style: theme.textTheme.bodyMedium?.copyWith(
            //           color: theme.colorScheme.outline,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   ),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: _handleGuestLogin,
                icon: const Icon(Icons.person_outline),
                label: Text(
                  tr.or_sign_in_later,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLoginButtons(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        const Text(
          'Or continue with',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              onPressed: _signInWithGoogle,
              icon: const Icon(
                Icons.g_mobiledata,
                color: Colors.red,
                size: 32,
              ),
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required Widget icon,
    required Color backgroundColor,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: icon,
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ThemeData theme, AppLocalizations tr) {
    return Center(
      child: Text(
        tr.app_version,
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }

  void _showLanguageSelection(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(tr.select_language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('English'),
              onTap: () {
                _updateLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Tiếng Việt'),
              onTap: () {
                _updateLocale(const Locale('vi'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateLocale(Locale locale) {
    context.read<LocaleCubit>().setLocale(locale);
  }
}