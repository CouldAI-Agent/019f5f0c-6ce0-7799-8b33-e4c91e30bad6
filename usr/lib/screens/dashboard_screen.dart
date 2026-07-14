import 'package:flutter/material.dart';
import '../models/leave_request.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final int totalVacationDays = 20;
  final int usedVacationDays = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Management'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceCard(context),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Requests',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to full list (placeholder)
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRequestsList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/request');
          if (result == true) {
            setState(() {});
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBalanceItem('Total Days', totalVacationDays.toString()),
          _buildBalanceItem('Used', usedVacationDays.toString()),
          _buildBalanceItem(
            'Available',
            (totalVacationDays - usedVacationDays).toString(),
            isHighlight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, String value, {bool isHighlight = false}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isHighlight ? Theme.of(context).colorScheme.primary : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestsList() {
    if (mockRequests.isEmpty) {
      return const Center(child: Text('No leave requests found.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mockRequests.length,
      itemBuilder: (context, index) {
        final request = mockRequests[index];
        final dateFormat = DateFormat('MMM d, yyyy');
        
        Color statusColor;
        switch (request.status) {
          case 'Approved':
            statusColor = Colors.green;
            break;
          case 'Rejected':
            statusColor = Colors.red;
            break;
          default:
            statusColor = Colors.orange;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              request.leaveType,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('${dateFormat.format(request.startDate)} - ${dateFormat.format(request.endDate)}'),
                const SizedBox(height: 4),
                Text('Reason: ${request.reason}'),
              ],
            ),
            trailing: Chip(
              label: Text(
                request.status,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: statusColor,
            ),
          ),
        );
      },
    );
  }
}
