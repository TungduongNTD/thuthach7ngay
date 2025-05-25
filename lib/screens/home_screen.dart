import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:thuthach7ngay/blocs/selected_day_cubit.dart';
import 'package:thuthach7ngay/models/habit_model.dart';
import 'package:thuthach7ngay/models/selected_day_model.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get_it/get_it.dart';
import '../cubit/habit_cubit.dart';
import '../l10n/app_localizations.dart';
import 'package:thuthach7ngay/blocs/new_habit_cubit.dart';

final GetIt getIt = GetIt.instance;
final tr = getIt.get<AppLocalizations>();
const Radius defaultBorderRadius = Radius.circular(15);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    ThemeData themeData = Theme.of(context);
    final Color primaryColor = themeData.colorScheme.primary;
    final Color backgroundColor = themeData.colorScheme.background;
    final Color surfaceColor = themeData.colorScheme.surface;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.push('/settings'),
          icon: Icon(Icons.settings, color: primaryColor),
          tooltip: 'Settings',
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.analytics, color: primaryColor),
            tooltip: 'Statistics',
          ),
          IconButton(
            onPressed: () =>
                context.go('/habits/new'), // Sử dụng go thay vì push
            icon: Icon(Icons.add_circle, color: primaryColor, size: 28),
            tooltip: 'Add Habit',
          ),
        ],
        title: Text(
          tr.app_name,
          style: themeData.textTheme.headlineSmall?.copyWith(
            fontFamily: 'Montserrat',
            color: primaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              // Greeting and date
              _buildGreetingSection(themeData),
              const SizedBox(height: 16),

              // Calendar section
              _buildCalendarSection(context, themeData),
              const SizedBox(height: 16),

              // Habits list
              Expanded(child: _buildHabitsList(themeData)),
            ],
          ),
        ),
      ),
    ); // Đã thêm dấu ngoặc đóng này cho phương thức build
  }

  Widget _buildGreetingSection(ThemeData themeData) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData greetingIcon;
    if (hour < 12) {
      greeting = 'Chào buổi sáng';
      greetingIcon = Icons.wb_sunny_rounded;
    } else if (hour < 17) {
      greeting = 'Chào buổi chiều';
      greetingIcon = Icons.wb_cloudy_rounded;
    } else {
      greeting = 'Chào buổi tối';
      greetingIcon = Icons.nightlight_round;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              greeting,
              style: themeData.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: themeData.colorScheme.onBackground,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              greetingIcon,
              color: themeData.colorScheme.primary,
              size: 28,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat(
                  'EEEE, d MMMM, y', Localizations.localeOf(context).toString())
              .format(DateTime.now()),
          style: themeData.textTheme.bodyMedium?.copyWith(
            color: themeData.colorScheme.onBackground.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCalendarSection(BuildContext context, ThemeData themeData) {
    final locale = Localizations.localeOf(context);
    return Container(
      decoration: BoxDecoration(
        color: themeData.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: CalendarHabits(locale: locale),
    );
  }

  Widget _buildHabitsList(ThemeData themeData) {
    return BlocBuilder<SelectedDayCubit, SelectedDay>(
      builder: (context, selectedDay) {
        List<Habit> habitsToShow = selectedDay.habits;

        if (habitsToShow.isEmpty) {
          return _buildEmptyState(themeData);
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: habitsToShow.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildHabitItem(themeData, habitsToShow[index], index),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData themeData) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   'assets/images/no_habits.png',
          //   height: 150,
          //   color: themeData.colorScheme.primary.withOpacity(0.5),
          // ),
          const SizedBox(height: 20),
          Text(
            tr.no_habits,
            style: themeData.textTheme.titleMedium?.copyWith(
              color: themeData.colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => context.push('/habits/new'),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeData.colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Tạo thói quen đầu tiên của bạn',
              style: themeData.textTheme.bodyMedium?.copyWith(
                color: themeData.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitItem(ThemeData themeData, Habit habit, int index) {
    // Tính toán tiến độ hoàn thành
    final totalDays = habit.duration;
    final completedDays = habit.doneOn.length;
    final progress = totalDays > 0 ? completedDays / totalDays : 0.0;
    final completionRate = (progress * 100).round();

    return Opacity(
      opacity: habit.isPaused ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: themeData.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Habit header
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: habit.isDone
                      ? themeData.colorScheme.primary.withOpacity(0.1)
                      : themeData.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  IconData(habit.icon, fontFamily: 'MaterialIcons'),
                  color: habit.isDone
                      ? themeData.colorScheme.primary
                      : themeData.colorScheme.onPrimaryContainer,
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      habit.name,
                      style: themeData.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration:
                            habit.isDone ? TextDecoration.lineThrough : null,
                        color: habit.isDone
                            ? themeData.colorScheme.onSurface.withOpacity(0.6)
                            : themeData.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (habit.isPaused)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Tạm dừng',
                          style: themeData.textTheme.bodySmall?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Text(
                '${habit.streak} ngày liên tiếp',
                style: themeData.textTheme.bodySmall?.copyWith(
                  color: themeData.colorScheme.primary,
                ),
              ),
              trailing: habit.isPaused
                  ? null
                  : Switch(
                      value: habit.isDone,
                      onChanged: (_) => context
                          .read<SelectedDayCubit>()
                          .changeHabitDone(index),
                      activeColor: themeData.colorScheme.primary,
                    ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: themeData.colorScheme.surfaceVariant,
                color: themeData.colorScheme.primary,
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),

            // Details row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildDetailChip(
                    'Streak: ${habit.streak}',
                    themeData,
                  ),
                  const SizedBox(width: 8),
                  _buildDetailChip(
                    '$completionRate% hoàn thành',
                    themeData,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.more_vert,
                        color:
                            themeData.colorScheme.onSurface.withOpacity(0.6)),
                    onPressed: () => _showHabitOptions(context, habit),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(String label, ThemeData themeData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: themeData.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: themeData.textTheme.bodySmall?.copyWith(
          color: themeData.colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showHabitOptions(BuildContext context, Habit habit) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Chỉnh sửa'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/habits/${habit.id}');
                },
              ),
              ListTile(
                //
                leading: Icon(habit.isPaused ? Icons.play_arrow : Icons.pause),
                title: Text(habit.isPaused ? 'Tiếp tục' : 'Tạm dừng'),
                onTap: () async {
                  Navigator.pop(context);
                  await context
                      .read<HabitCubit>()
                      .pauseHabit(habit.id, !habit.isPaused);
                  await context.read<SelectedDayCubit>().changeSelectedDay(
                        context.read<SelectedDayCubit>().state.selectedDay,
                      );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Xóa'),
                onTap: () async {
                  Navigator.pop(context);
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
                          child:
                              Text('Xóa', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (shouldDelete == true) {
                    await context.read<HabitCubit>().deleteHabit(habit.id);
                    await context.read<SelectedDayCubit>().changeSelectedDay(
                          context.read<SelectedDayCubit>().state.selectedDay,
                        );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPauseHabitDialog(BuildContext context, String habitId) {
    int selectedDays = 3;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Tạm ngưng thói quen'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Chọn thời gian tạm ngưng:'),
                const SizedBox(height: 16),
                DropdownButton<int>(
                  value: selectedDays,
                  items: [1, 3, 7, 14].map((days) {
                    return DropdownMenuItem(
                      value: days,
                      child: Text('$days ngày'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedDays = value!);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  // Xử lý tạm ngưng
                  await context.read<HabitCubit>().pauseHabit(habitId, true);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã tạm ngưng thói quen')),
                  );
                },
                child: Text('Xác nhận'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CalendarHabits extends StatelessWidget {
  final Locale locale;
  const CalendarHabits({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return BlocBuilder<SelectedDayCubit, SelectedDay>(
      builder: (context, selectedDay) {
        return TableCalendar(
          locale: locale.toString(),
          firstDay: DateTime.now().subtract(const Duration(days: 365)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: selectedDay.selectedDay,
          calendarFormat: CalendarFormat.week,
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerVisible: false,
          daysOfWeekHeight: 36,
          rowHeight: 42,
          availableGestures: AvailableGestures.horizontalSwipe,
          selectedDayPredicate: (day) =>
              isSameDay(selectedDay.selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) async {
            await context.read<SelectedDayCubit>().changeSelectedDay(
                  selectedDay,
                );
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: themeData.colorScheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: themeData.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            defaultDecoration: BoxDecoration(shape: BoxShape.circle),
            weekendTextStyle: TextStyle(color: themeData.colorScheme.onSurface),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: themeData.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            weekendStyle: TextStyle(
              color: themeData.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              return Center(
                child: Text(
                  day.day.toString(),
                  style: TextStyle(
                    color: isSameDay(day, DateTime.now())
                        ? themeData.colorScheme.primary
                        : themeData.colorScheme.onSurface,
                    fontWeight: isSameDay(day, DateTime.now())
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: themeData.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: themeData.colorScheme.primary,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: themeData.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
            dowBuilder: (context, day) {
              final text = DateFormat.E(
                locale.toString(),
              ).format(day).replaceAll('.', '');
              return Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: themeData.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class HabitItem extends StatefulWidget {
  final String title;
  final String? description;
  final IconData icon;
  final IconData? iconDescription;
  final int index;
  final bool isDone;

  const HabitItem({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    this.iconDescription,
    required this.index,
    required this.isDone,
  });

  @override
  State<HabitItem> createState() => _HabitItemState();
}

class _HabitItemState extends State<HabitItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final bool isExpanded = context.select<SelectedDayCubit, bool>(
      (cubit) => cubit.state.habits[widget.index].isExpanded,
    );

    if (isExpanded && !_animationController.isAnimating) {
      _animationController.forward();
    } else if (!isExpanded && _animationController.isAnimating) {
      _animationController.reverse();
    }

    return BlocBuilder<SelectedDayCubit, SelectedDay>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: themeData.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.isDone
                        ? themeData.colorScheme.primary.withOpacity(0.2)
                        : themeData.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.isDone
                        ? themeData.colorScheme.primary
                        : themeData.colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(
                  widget.title,
                  style: themeData.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    decoration:
                        widget.isDone ? TextDecoration.lineThrough : null,
                    color: widget.isDone
                        ? themeData.colorScheme.onSurface.withOpacity(0.6)
                        : themeData.colorScheme.onSurface,
                  ),
                ),
                subtitle: widget.description != null
                    ? Row(
                        children: [
                          Icon(
                            widget.iconDescription,
                            size: 16,
                            color: widget.isDone
                                ? themeData.colorScheme.primary
                                : themeData.colorScheme.onSurface
                                    .withOpacity(0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.description!,
                            style: themeData.textTheme.bodySmall?.copyWith(
                              color: widget.isDone
                                  ? themeData.colorScheme.primary
                                  : themeData.colorScheme.onSurface
                                      .withOpacity(0.6),
                            ),
                          ),
                        ],
                      )
                    : null,
                trailing: IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_arrow,
                    progress: _animation,
                    color: themeData.colorScheme.onSurface.withOpacity(0.6),
                  ),
                  onPressed: () {
                    context.read<SelectedDayCubit>().changeHabitExpanded(
                          widget.index,
                        );
                  },
                ),
                onTap: () {
                  context.read<SelectedDayCubit>().changeHabitExpanded(
                        widget.index,
                      );
                },
              ),

              // Expanded content
              SizeTransition(
                sizeFactor: _animation,
                child: _buildExpandedContent(context, state, themeData),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpandedContent(
    BuildContext context,
    SelectedDay state,
    ThemeData themeData,
  ) {
    final habit = state.habits[widget.index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          if (habit.description.isNotEmpty) ...[
            Text(
              habit.description,
              style: themeData.textTheme.bodyMedium?.copyWith(
                color: themeData.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
          ],

          // Streak counter
          _buildStreakCounter(themeData),
          const SizedBox(height: 16),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () => context.push('/habits/${habit.id}'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: themeData.colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Chỉnh sửa',
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    color: themeData.colorScheme.primary,
                  ),
                ),
              ),
              MarkAsDoneButton(
                index: widget.index,
                state: state,
                isDone: widget.isDone,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCounter(ThemeData themeData) {
    // This would be replaced with actual streak data from your model
    const currentStreak = 5;
    const longestStreak = 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thống kê',
          style: themeData.textTheme.bodySmall?.copyWith(
            color: themeData.colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildStreakBox(
                'Ngắn nhất',
                '$currentStreak ngày',
                themeData.colorScheme.primary.withOpacity(0.1),
                themeData,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStreakBox(
                'Dài nhất',
                '$longestStreak ngày',
                themeData.colorScheme.secondary.withOpacity(0.1),
                themeData,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakBox(
    String title,
    String value,
    Color color,
    ThemeData themeData,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: themeData.textTheme.bodySmall?.copyWith(
              color: themeData.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: themeData.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: themeData.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class MarkAsDoneButton extends StatefulWidget {
  final int index;
  final SelectedDay state;
  final bool isDone;

  const MarkAsDoneButton({
    super.key,
    required this.index,
    required this.state,
    required this.isDone,
  });

  @override
  State<MarkAsDoneButton> createState() => _MarkAsDoneButtonState();
}

class _MarkAsDoneButtonState extends State<MarkAsDoneButton> {
  late ConfettiController _confettiController;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            if (!widget.isDone) {
              setState(() => _isAnimating = true);
              _confettiController.play();
              await Future.delayed(const Duration(milliseconds: 500));
              setState(() => _isAnimating = false);
            }
            await context.read<SelectedDayCubit>().changeHabitDone(
                  widget.index,
                );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.isDone
                ? themeData.colorScheme.surfaceVariant
                : themeData.colorScheme.primary,
            foregroundColor: widget.isDone
                ? themeData.colorScheme.onSurfaceVariant
                : themeData.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isAnimating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    widget.isDone ? 'Hoàn tác' : 'Hoàn thành',
                    style: themeData.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.white, Colors.yellow],
          createParticlePath: _drawStar,
          numberOfParticles: 20,
          gravity: 0.2,
        ),
      ],
    );
  }

  Path _drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(
        halfWidth + externalRadius * cos(step),
        halfWidth + externalRadius * sin(step),
      );
      path.lineTo(
        halfWidth + internalRadius * cos(step + halfDegreesPerStep),
        halfWidth + internalRadius * sin(step + halfDegreesPerStep),
      );
    }
    path.close();
    return path;
  }
}
