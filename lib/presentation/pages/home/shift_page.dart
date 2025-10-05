import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/date_formatter.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/shift/shift_bloc.dart';
import '../../bloc/shift/shift_event.dart';
import '../../bloc/shift/shift_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../auth/login_page.dart';

class ShiftPage extends StatefulWidget {
  const ShiftPage({super.key});

  @override
  State<ShiftPage> createState() => _ShiftPageState();
}

class _ShiftPageState extends State<ShiftPage> {
  final _reportController = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    context.read<ShiftBloc>().add(LoadShiftsEvent());
    
    // Update timer every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _reportController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _showFinishDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Завершить смену'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Добавьте краткий отчет о проделанной работе:'),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _reportController,
              label: 'Отчет',
              hint: 'Что было сделано...',
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ShiftBloc>().add(
                    FinishShiftEvent(report: _reportController.text),
                  );
              _reportController.clear();
            },
            child: const Text('Завершить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Моя смена'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ShiftBloc, ShiftState>(
        listener: (context, state) {
          if (state is ShiftError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ShiftActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ShiftLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ShiftLoaded) {
            final activeShift = state.activeShift;
            final hasActiveShift = activeShift != null;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ShiftBloc>().add(LoadShiftsEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStatusCard(context, hasActiveShift, activeShift),
                    const SizedBox(height: 24),
                    if (hasActiveShift)
                      CustomButton(
                        text: 'Завершить смену',
                        onPressed: () => _showFinishDialog(context),
                        icon: Icons.stop_circle_outlined,
                      )
                    else
                      CustomButton(
                        text: 'Начать смену',
                        onPressed: () {
                          context.read<ShiftBloc>().add(StartShiftEvent());
                        },
                        icon: Icons.play_circle_outline,
                      ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Нет данных о сменах',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Начать смену',
                  onPressed: () {
                    context.read<ShiftBloc>().add(StartShiftEvent());
                  },
                  icon: Icons.play_circle_outline,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, bool hasActiveShift, activeShift) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: hasActiveShift
                ? [Colors.green.shade400, Colors.green.shade600]
                : [Colors.grey.shade300, Colors.grey.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Icon(
              hasActiveShift ? Icons.work : Icons.work_off,
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              hasActiveShift ? 'Смена активна' : 'Нет активной смены',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (hasActiveShift) ...[
              const SizedBox(height: 24),
              _buildInfoRow(
                'Начало',
                DateFormatter.formatDateTime(activeShift.startTime, 'ru_RU'),
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                'Длительность',
                DateFormatter.formatDuration(
                  DateTime.now().difference(activeShift.startTime),
                  'ru_RU',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
