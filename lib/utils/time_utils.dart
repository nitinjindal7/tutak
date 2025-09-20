class TimeUtils {
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '${hours}h ${remainingMinutes}min';
    }
  }

  static int timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  static String minutesToTime(int minutes) {
    final hours = (minutes ~/ 60) % 24;
    final mins = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }

  static bool isTimeBetween(String currentTime, String startTime, String endTime) {
    final current = timeToMinutes(currentTime);
    final start = timeToMinutes(startTime);
    final end = timeToMinutes(endTime);
    
    if (start <= end) {
      return current >= start && current <= end;
    } else {
      //跨越午夜的时间段
      return current >= start || current <= end;
    }
  }

  static String getCurrentTimeString() {
    final now = DateTime.now();
    return formatTime(now);
  }

  static String getDayType() {
    final now = DateTime.now();
    return now.weekday < 6 ? 'weekday' : 'weekend';
  }
}