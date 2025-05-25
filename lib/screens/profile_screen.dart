import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/selected_day_model.dart';
import '../models/user_hive_model.dart';
import '../l10n/app_localizations.dart';
import '../blocs/selected_day_cubit.dart';
import '../models/habit_model.dart';
import 'ai_assistant.dart';

final GetIt getIt = GetIt.instance;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _goalController;
  File? _profileImage;
  bool _isEditing = false;
  bool _isLoading = false;
  final _userBox = Hive.box<UserHive>('userBox');
  UserHive? _currentUser;
  final _imagePicker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    _currentUser = _userBox.get('currentUser');
    _nameController =
        TextEditingController(text: _currentUser?.name ?? 'Guest User');
    _ageController = TextEditingController(text: '28');
    _heightController = TextEditingController(text: '175');
    _goalController = TextEditingController(
        text: _currentUser?.loginMethod == 'guest'
            ? tr.sign_in_to_set_goals
            : tr.improve_my_health);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
        );
      }
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedUser = _currentUser?.copyWith(
        name: _nameController.text,
        // Add other fields as needed
      );

      if (updatedUser != null) {
        await _userBox.put('currentUser', updatedUser);
        setState(() {
          _currentUser = updatedUser;
          _isEditing = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr.profile_updated_successfully)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr.failed_to_update_profile)),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr.logout_confirmation),
        content: Text(tr.logout_confirmation_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(tr.logout),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    setState(() => _isLoading = true);
    try {
      await _auth.signOut();
      await _userBox.delete('currentUser');
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _linkWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Link tài khoản Google với tài khoản guest hiện tại
      final UserCredential userCredential =
          await _auth.currentUser!.linkWithCredential(credential);

      if (userCredential.user != null) {
        // Cập nhật thông tin người dùng trong Hive
        final updatedUser = UserHive(
          id: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'Google User',
          email: userCredential.user!.email ?? '',
          photoUrl: userCredential.user!.photoURL,
          loginMethod: 'google',
        );

        await _userBox.put('currentUser', updatedUser);

        if (mounted) {
          setState(() {
            _currentUser = updatedUser;
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account upgraded to Google successfully')),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to link with Google: ${e.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
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

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(tr.profile),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_currentUser?.loginMethod != 'guest' &&
              _currentUser?.loginMethod != 'anonymous')
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit),
              onPressed:
                  _isLoading ? null : (_isEditing ? _saveProfile : _toggleEdit),
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildProfileHeader(theme),
                  const SizedBox(height: 24),
                  _buildProfileForm(theme),
                  const SizedBox(height: 24),
                  _buildHabitsProgressSection(context),
                  const SizedBox(height: 24),
                  _buildStatsSection(context),
                  const SizedBox(height: 24),
                  if (_currentUser?.loginMethod == 'guest' ||
                      _currentUser?.loginMethod == 'anonymous')
                    _buildGuestActions(theme),
                  if (_currentUser?.loginMethod != 'guest' &&
                      _currentUser?.loginMethod != 'anonymous')
                    _buildLogoutButton(theme),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Hero(
              tag: 'profile_image',
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : _currentUser?.photoUrl != null
                        ? NetworkImage(_currentUser!.photoUrl!) as ImageProvider
                        : const AssetImage('') as ImageProvider,
                child: _profileImage == null && _currentUser?.photoUrl == null
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: theme.colorScheme.onSurfaceVariant,
                      )
                    : null,
              ),
            ),
            if (_isEditing &&
                _currentUser?.loginMethod != 'guest' &&
                _currentUser?.loginMethod != 'anonymous')
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: theme.colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (!_isEditing)
          Column(
            children: [
              Text(
                _nameController.text,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_currentUser?.email != null)
                Text(
                  _currentUser!.email!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              if (_currentUser?.loginMethod != null)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _currentUser!.loginMethod == 'google'
                            ? Icons.g_mobiledata
                            : _currentUser!.loginMethod == 'email'
                                ? Icons.email
                                : Icons.person_outline,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _currentUser!.loginMethod == 'google'
                            ? tr.google_account
                            : _currentUser!.loginMethod == 'email'
                                ? tr.email_account
                                : tr.guest_account,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildProfileForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr.personal_information,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          enabled: _isEditing,
          decoration: InputDecoration(
            labelText: tr.name,
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr.please_enter_name;
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _ageController,
                enabled: _isEditing,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: tr.age,
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr.please_enter_age;
                  }
                  if (int.tryParse(value) == null) {
                    return tr.please_enter_valid_number;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _heightController,
                enabled: _isEditing,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: tr.height,
                  prefixIcon: const Icon(Icons.height),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr.please_enter_height;
                  }
                  if (int.tryParse(value) == null) {
                    return tr.please_enter_valid_number;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _goalController,
          enabled: _isEditing,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: tr.goals,
            prefixIcon: const Icon(Icons.flag_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr.please_enter_goal;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildHabitsProgressSection(BuildContext context) {
    final theme = Theme.of(context);
    final tr = AppLocalizations.of(context)!;

    return BlocBuilder<SelectedDayCubit, SelectedDay>(
      builder: (context, state) {
        final habits = state.habits;
        if (habits.isEmpty) return const SizedBox();

        // Tính toán các chỉ số
        final totalHabits = habits.length;
        final completedHabits = habits.where((h) => h.isDone).length;
        final completionRate =
            totalHabits > 0 ? (completedHabits / totalHabits * 100).round() : 0;
        final activeDays =
            habits.fold(0, (sum, habit) => sum + habit.doneOn.length);
        final longestStreak = habits.isNotEmpty
            ? habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b)
            : 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thói quen tiến bộ',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Progress bar đơn giản
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tiến độ hôm nay',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '$completionRate%',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: completionRate / 100,
                        backgroundColor: theme.colorScheme.surfaceVariant,
                        color: theme.colorScheme.primary,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Thống kê dạng số với icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProgressStat(
                        context: context,
                        icon: Icons.check_circle,
                        value: '$completedHabits/$totalHabits',
                        label: 'Hoàn thành',
                        color: theme.colorScheme.primary,
                      ),
                      _buildProgressStat(
                        context: context,
                        icon: Icons.calendar_today,
                        value: '$activeDays',
                        label: 'Ngày hoạt động',
                        color: theme.colorScheme.secondary,
                      ),
                      _buildProgressStat(
                        context: context,
                        icon: Icons.trending_up,
                        value: '$longestStreak',
                        label: 'Streak dài nhất',
                        color: theme.colorScheme.tertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressStat({
    required BuildContext context,
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final theme = Theme.of(context);
    final tr = AppLocalizations.of(context)!;

    return BlocBuilder<SelectedDayCubit, SelectedDay>(
      builder: (context, state) {
        final habits = state.habits;

        // Tính toán các thống kê từ danh sách thói quen
        final totalCompleted =
            habits.fold(0, (sum, habit) => sum + habit.doneOn.length);
        final longestStreak = habits.isNotEmpty
            ? habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b)
            : 0;
        final activeDays = habits.isNotEmpty
            ? habits.map((h) => h.doneOn.length).reduce((a, b) => a + b)
            : 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.statistics,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  theme,
                  icon: Icons.calendar_today,
                  title: tr.days_active,
                  value: '$activeDays',
                ),
                _buildStatCard(
                  theme,
                  icon: Icons.check_circle_outline,
                  title: tr.habits_completed,
                  value: '$totalCompleted',
                ),
                _buildStatCard(
                  theme,
                  icon: Icons.trending_up,
                  title: 'Chuỗi dài nhất',
                  value: '$longestStreak days',
                ),
                _buildStatCard(
                  theme,
                  icon: Icons.emoji_events_outlined,
                  title: tr.achievements,
                  value: '${habits.where((h) => h.isDone).length}',
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGuestActions(ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.g_mobiledata),
            label: const Text('Upgrade to Google Account'),
            onPressed: _isLoading ? null : _linkWithGoogle,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Continue as Guest'),
            onPressed: _isLoading ? null : _logout,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.logout),
        label: Text(tr.logout),
        onPressed: _logout,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(color: theme.colorScheme.error),
        ),
      ),
    );
  }
}
