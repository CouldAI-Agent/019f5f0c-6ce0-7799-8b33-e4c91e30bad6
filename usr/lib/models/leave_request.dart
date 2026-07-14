class LeaveRequest {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String leaveType;
  final String reason;
  final String status; // 'Pending', 'Approved', 'Rejected'

  LeaveRequest({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.leaveType,
    required this.reason,
    this.status = 'Pending',
  });
}

// Mock data
List<LeaveRequest> mockRequests = [
  LeaveRequest(
    id: '1',
    startDate: DateTime.now().subtract(const Duration(days: 30)),
    endDate: DateTime.now().subtract(const Duration(days: 28)),
    leaveType: 'Vacation',
    reason: 'Family trip',
    status: 'Approved',
  ),
  LeaveRequest(
    id: '2',
    startDate: DateTime.now().add(const Duration(days: 15)),
    endDate: DateTime.now().add(const Duration(days: 18)),
    leaveType: 'Sick Leave',
    reason: 'Medical appointment',
    status: 'Pending',
  ),
];
