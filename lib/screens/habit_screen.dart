import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:thuthach7ngay/blocs/new_habit_cubit.dart';
import '../l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'custom_habit_screen.dart';
import 'package:thuthach7ngay/blocs/selected_day_cubit.dart';

final GetIt getIt = GetIt.instance;
final tr = getIt.get<AppLocalizations>();

class HabitScreen extends StatefulWidget {
  final String? id;
  const HabitScreen({super.key, required this.id});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  int _selectedDays = 7;
  bool _customDaysUnlocked = false;
  IconData _selectedIcon = Icons.self_improvement;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 8, minute: 0);
  bool _enableNotification = false;

  // Danh sách thói quen được lập trình sẵn
  final List<Map<String, dynamic>> predefinedHabits = [
    {
      'name': 'Thiền',
      'icon': Icons.self_improvement,
      'description': 'Tĩnh tâm mỗi ngày'
    },
    {
      'name': 'Chạy bộ',
      'icon': Icons.directions_run,
      'description': 'Rèn luyện sức khỏe'
    },
    {
      'name': 'Đọc sách',
      'icon': Icons.menu_book,
      'description': 'Mở mang kiến thức'
    },
    {
      'name': 'Viết nhật ký',
      'icon': Icons.edit_note,
      'description': 'Ghi lại cảm xúc'
    },
    {
      'name': 'Làm việc',
      'icon': Icons.work,
      'description': 'Tập trung làm việc'
    },
    {
      'name': 'Tập gym',
      'icon': Icons.fitness_center,
      'description': 'Rèn luyện cơ bắp'
    },
    {
      'name': 'Đạp xe',
      'icon': Icons.directions_bike,
      'description': 'Vận động cơ thể'
    },
    {
      'name': 'Đi dạo',
      'icon': Icons.directions_walk,
      'description': 'Thư giãn tinh thần'
    },
    {
      'name': 'Uống nước',
      'icon': Icons.local_drink,
      'description': 'Giữ cơ thể đủ nước'
    },
    {
      'name': 'Ngủ đúng giờ',
      'icon': Icons.nightlight_round,
      'description': 'Nâng cao chất lượng giấc ngủ'
    },
    {
      'name': 'Ăn rau',
      'icon': Icons.eco,
      'description': 'Bổ sung chất xơ'
    },
    {
      'name': 'Chơi cầu lông',
      'icon': Icons.sports_tennis,
      'description': 'Rèn luyện thể thao'
    },
    {
      'name': 'Hát',
      'icon': Icons.mic,
      'description': 'Giải tỏa căng thẳng'
    },
    {
      'name': 'Học ngoại ngữ',
      'icon': Icons.language,
      'description': 'Mở rộng kiến thức'
    },
  ];

  // Danh sách ngày thử thách
  final List<int> challengeDays = [7, 14, 21, 30];

  // Thói quen được đề xuất ngẫu nhiên
  Map<String, dynamic> get recommendedHabit {
    final randomHabits = List.of(predefinedHabits)..shuffle();
    return randomHabits.first;
  }

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      context.read<NewHabitCubit>().getHabitToEdit(widget.id!).then((_) {
        if (mounted) {
          final state = context.read<NewHabitCubit>().state;
          _nameController.text = state.name;
          _descriptionController.text = state.description;
          _selectedIcon = IconData(state.iconCodePoint, fontFamily: 'MaterialIcons');
          _enableNotification = state.enableNotification;
          // Convert notificationTime String to TimeOfDay
          final parts = state.notificationTime.split(':');
          _notificationTime = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
          _customDaysUnlocked = state.daysCompleted >= 6;
          if (_customDaysUnlocked) {
            _selectedDays = state.duration;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isEditing = widget.id != null;

    return Scaffold(
      backgroundColor: themeData.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeData.colorScheme.onBackground),
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          isEditing ? tr.edit_habit : tr.new_habit,
          style: themeData.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: themeData.colorScheme.onBackground,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phần đề xuất thói quen
                  _buildRecommendationSection(themeData),
                  const SizedBox(height: 24),

                  // Tiêu đề phần chọn thói quen
                  Text(
                    'Chọn thói quen của bạn',
                    style: themeData.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: themeData.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Grid view các thói quen được lập trình sẵn
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.8,
                    ),
                    itemCount: predefinedHabits.length,
                    itemBuilder: (context, index) {
                      return _buildHabitCard(
                        themeData,
                        predefinedHabits[index]['name'],
                        predefinedHabits[index]['icon'],
                        predefinedHabits[index]['description'],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Phần tạo thói quen tùy chỉnh
                  Text(
                    'Hoặc tạo thói quen của riêng bạn',
                    style: themeData.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: themeData.colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CustomHabitScreen()),
                      );
                      
                      if (result != null) {
                        // Handle the returned habit data
                        _nameController.text = result['name'];
                        _descriptionController.text = result['description'];
                        setState(() {
                          _selectedDays = result['duration'];
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeData.colorScheme.surface,
                      foregroundColor: themeData.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('Tạo thói quen tùy chỉnh'),
                  ),
                  const SizedBox(height: 24),

                  // Tên thói quen
                  _buildHabitNameField(themeData),
                  const SizedBox(height: 16),

                  // Mô tả thói quen
                  _buildDescriptionField(themeData),
                  const SizedBox(height: 24),

                  // Chọn số ngày thử thách
                  _buildChallengeDaysSelector(themeData),
                  const SizedBox(height: 32),

                  // Add notification settings
                  _buildNotificationSettings(themeData),
                  const SizedBox(height: 24),

                  // Nút lưu
                  _buildSaveButton(themeData),
                  if (isEditing) _buildDeleteButton(themeData),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationSection(ThemeData themeData) {
    final habit = recommendedHabit;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeData.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dựa trên các thói quen của bạn',
            style: themeData.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: themeData.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thêm thói quen "${habit['name']}" giúp ${habit['description']}',
            style: themeData.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              _nameController.text = habit['name'];
              _descriptionController.text = habit['description'];
              // Có thể thêm logic chọn icon tương ứng ở đây
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: themeData.colorScheme.primary,
              foregroundColor: themeData.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text('Chọn thói quen này'),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard(ThemeData themeData, String title, IconData icon, String description) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: themeData.colorScheme.primary.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _nameController.text = title;
          _descriptionController.text = description;
          setState(() {
            _selectedIcon = icon;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: themeData.colorScheme.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: themeData.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: themeData.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: themeData.textTheme.bodySmall?.copyWith(
                        color: themeData.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHabitNameField(ThemeData themeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tên thói quen',
          style: themeData.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: themeData.colorScheme.onBackground.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Ví dụ: Uống nước, Đọc sách...',
            filled: true,
            fillColor: themeData.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Vui lòng nhập tên thói quen';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField(ThemeData themeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mô tả',
          style: themeData.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: themeData.colorScheme.onBackground.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Mô tả ngắn về thói quen...',
            filled: true,
            fillColor: themeData.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeDaysSelector(ThemeData themeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thời gian thử thách',
          style: themeData.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: themeData.colorScheme.onBackground.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: challengeDays.map((days) {
            final isAvailable = days == 7 || _customDaysUnlocked;
            return ChoiceChip(
              label: Text('$days ngày'),
              selected: _selectedDays == days,
              onSelected: isAvailable
                  ? (selected) {
                setState(() {
                  _selectedDays = days;
                });
              }
                  : null,
              selectedColor: themeData.colorScheme.primary,
              labelStyle: TextStyle(
                color: _selectedDays == days
                    ? themeData.colorScheme.onPrimary
                    : isAvailable
                    ? themeData.colorScheme.onSurface
                    : themeData.colorScheme.onSurface.withOpacity(0.3),
              ),
              backgroundColor: themeData.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }).toList(),
        ),
        if (!_customDaysUnlocked && _selectedDays == 7)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Hoàn thành ≥6/7 ngày để mở khóa thử thách dài hơn',
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationSettings(ThemeData themeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông báo nhắc nhở',
          style: themeData.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: themeData.colorScheme.onBackground.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Bật thông báo',
            style: themeData.textTheme.bodyMedium,
          ),
          value: _enableNotification,
          onChanged: (value) {
            setState(() {
              _enableNotification = value;
            });
          },
          activeColor: themeData.colorScheme.primary,
        ),
        if (_enableNotification) ...[
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.access_time,
              color: themeData.colorScheme.primary,
            ),
            title: Text(
              'Thời gian nhắc nhở',
              style: themeData.textTheme.bodyMedium,
            ),
            trailing: Text(
              _notificationTime.format(context),
              style: themeData.textTheme.bodyMedium?.copyWith(
                color: themeData.colorScheme.primary,
              ),
            ),
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: _notificationTime,
              );
              if (picked != null && picked != _notificationTime) {
                setState(() {
                  _notificationTime = picked;
                });
              }
            },
          ),
        ],
      ],
    );
  }

  Widget _buildSaveButton(ThemeData themeData) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Xử lý lưu thói quen
            _saveHabit(themeData);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: themeData.colorScheme.primary,
          foregroundColor: themeData.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          'Lưu thói quen',
          style: themeData.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _saveHabit(ThemeData themeData) async {
    setState(() => _isLoading = true);
    try {
      if (widget.id != null) {
        await context.read<NewHabitCubit>().updateHabit(
          widget.id!,
          _nameController.text,
          _descriptionController.text,
          _selectedIcon.codePoint,
          _enableNotification,
          _notificationTime.format(context),
          _selectedDays,
        );
      } else {
        await context.read<NewHabitCubit>().addNewHabit(
          _nameController.text,
          _descriptionController.text,
          _selectedIcon.codePoint,
          _enableNotification,
          _notificationTime.format(context),
          _selectedDays,
        );
      }
      
      // Force reload lại danh sách thói quen
      await context.read<SelectedDayCubit>().changeSelectedDay(
        context.read<SelectedDayCubit>().state.selectedDay
      );
      
      if (mounted) {
        // Điều hướng về màn hình chính
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu thói quen: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildDeleteButton(ThemeData themeData) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 32),
      child: Center(
        child: TextButton(
          onPressed: () async {
            final shouldDelete = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Xác nhận xóa'),
                content: Text('Bạn có chắc chắn muốn xóa thói quen này?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Hủy'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Xóa', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );

            if (shouldDelete == true) {
              await _deleteHabit();
            }
          },
          child: Text(
            'Xóa thói quen',
            style: TextStyle(
              color: themeData.colorScheme.error,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteHabit() async {
    setState(() => _isLoading = true);
    try {
      // Xóa thói quen
      await context.read<NewHabitCubit>().deleteHabit(widget.id!);
      
      // Force reload lại danh sách thói quen
      await context.read<SelectedDayCubit>().changeSelectedDay(
        context.read<SelectedDayCubit>().state.selectedDay
      );
      
      if (mounted) {
        // Điều hướng về màn hình chính
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa thói quen: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}