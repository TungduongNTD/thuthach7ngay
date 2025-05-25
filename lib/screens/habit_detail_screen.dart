import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/habit_cubit.dart';
import '../models/habit_model.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({Key? key, required this.habit}) : super(key: key);

  @override
  _HabitDetailScreenState createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  Future<void> _showDeleteConfirmationDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa thử thách này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        // Đợi cho việc xóa hoàn tất
        await context.read<HabitCubit>().deleteHabit(widget.habit.id);

        if (mounted) {
          // Đóng dialog nếu đang mở
          Navigator.of(context).pop();

          // Quay về màn hình chính và refresh
          Navigator.of(context).popUntil((route) => route.isFirst);

          // Hiển thị thông báo thành công
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Xóa thử thách thành công')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi khi xóa thử thách: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Implement the build method
    return Container();
  }
}
