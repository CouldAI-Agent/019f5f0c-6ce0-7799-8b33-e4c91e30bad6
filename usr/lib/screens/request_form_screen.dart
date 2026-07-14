import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/leave_request.dart';

class RequestFormScreen extends StatefulWidget {
  const RequestFormScreen({super.key});

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedLeaveType = 'Vacation';
  final List<String> _leaveTypes = ['Vacation', 'Sick Leave', 'Personal', 'Unpaid'];
  
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _reasonController = TextEditingController();

  final DateFormat _dateFormat = DateFormat('MMM d, yyyy');

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime initialDate = isStart 
        ? (_startDate ?? DateTime.now()) 
        : (_endDate ?? _startDate ?? DateTime.now());
        
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          if (_startDate != null && _startDate!.isAfter(_endDate!)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  void _submitRequest() {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select start and end dates')),
        );
        return;
      }

      final newRequest = LeaveRequest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        startDate: _startDate!,
        endDate: _endDate!,
        leaveType: _selectedLeaveType,
        reason: _reasonController.text,
      );

      mockRequests.insert(0, newRequest);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave request submitted successfully')),
      );
      
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Leave Request'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedLeaveType,
                  decoration: const InputDecoration(
                    labelText: 'Leave Type',
                    border: OutlineInputBorder(),
                  ),
                  items: _leaveTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLeaveType = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start Date',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _startDate == null ? 'Select Date' : _dateFormat.format(_startDate!),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'End Date',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _endDate == null ? 'Select Date' : _dateFormat.format(_endDate!),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason for leave',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _submitRequest,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Submit Request', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
