import 'package:flutter/material.dart';
import 'package:thuthach7ngay/l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;
final tr = getIt.get<AppLocalizations>();

class CustomHabitScreen extends StatefulWidget {
  const CustomHabitScreen({super.key});

  @override
  State<CustomHabitScreen> createState() => _CustomHabitScreenState();
}

class _CustomHabitScreenState extends State<CustomHabitScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedDays = 7;
  bool _customDaysUnlocked = false;
  IconData _selectedIcon = Icons.self_improvement;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 8, minute: 0);
  bool _enableNotification = false;

  // Danh sách ngày thử thách
  final List<int> challengeDays = [7, 14, 21, 30];

  // Danh sách icon phổ biến
  final List<IconData> availableIcons = [
    Icons.self_improvement,
    Icons.directions_run,
    Icons.menu_book,
    Icons.edit_note,
    Icons.work,
    Icons.fitness_center,
    Icons.directions_bike,
    Icons.directions_walk,
    Icons.local_drink,
    Icons.nightlight_round,
    Icons.eco,
    Icons.sports_tennis,
    Icons.mic,
    Icons.language,
    Icons.alarm,
    Icons.health_and_safety,
    Icons.medication,
    Icons.spa,
    Icons.music_note,
    Icons.brush,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectNotificationTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _notificationTime) {
      setState(() {
        _notificationTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      backgroundColor: themeData.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeData.colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          tr.new_habit,
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
                  const SizedBox(height: 16),
                  // Icon selection
                  _buildIconSelector(themeData),
                  const SizedBox(height: 24),

                  // Tên thói quen
                  _buildHabitNameField(themeData),
                  const SizedBox(height: 16),

                  // Mô tả thói quen
                  _buildDescriptionField(themeData),
                  const SizedBox(height: 24),

                  // Notification settings
                  _buildNotificationSettings(themeData),
                  const SizedBox(height: 24),

                  // Chọn số ngày thử thách
                  _buildChallengeDaysSelector(themeData),
                  const SizedBox(height: 32),

                  // Nút lưu
                  _buildSaveButton(themeData),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconSelector(ThemeData themeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chọn biểu tượng',
          style: themeData.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: themeData.colorScheme.onBackground.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: availableIcons.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final icon = availableIcons[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIcon = icon;
                  });
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _selectedIcon == icon
                        ? themeData.colorScheme.primary.withOpacity(0.2)
                        : themeData.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: _selectedIcon == icon
                        ? Border.all(
                            color: themeData.colorScheme.primary,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Icon(
                    icon,
                    size: 30,
                    color: _selectedIcon == icon
                        ? themeData.colorScheme.primary
                        : themeData.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              );
            },
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
            onTap: () => _selectNotificationTime(context),
          ),
        ],
      ],
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

  Widget _buildSaveButton(ThemeData themeData) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pop(context, {
              'name': _nameController.text,
              'description': _descriptionController.text,
              'duration': _selectedDays,
              'icon': _selectedIcon,
              'enableNotification': _enableNotification,
              'notificationTime': _enableNotification ? _notificationTime.format(context) : null,
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: themeData.colorScheme.primary,
          foregroundColor: themeData.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 2,
          shadowColor: themeData.colorScheme.primary.withOpacity(0.3),
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
}