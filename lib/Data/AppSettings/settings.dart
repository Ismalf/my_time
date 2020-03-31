class AppSettings {
  bool isDark;
  bool showPendingTasks;
  int daysToShow;
  bool splitDailyRoutine;
  bool reassingTasks;
  bool showAssignedTime;
  AppSettings({
    this.showAssignedTime = true,
    this.isDark = true,
    this.reassingTasks = true,
    this.showPendingTasks = true,
    this.daysToShow = 1,
    this.splitDailyRoutine = true,
  });

  setDarkMode(val) {
    isDark = val;
  }

  setPendingTasks(val) {
    showPendingTasks = val;
  }

  setDaysToShow(val) {
    daysToShow = val;
  }
}
