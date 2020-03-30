class AppSettings {
  bool isDark;
  bool showPendingTasks;
  int daysToShow;

  AppSettings(
      {this.isDark = true, this.showPendingTasks = true, this.daysToShow = 1});

  setDarkMode(val) {
    isDark = val;
  }

  setPendingTasks(val){
    showPendingTasks = val;
  }

  setDaysToShow(val){
    daysToShow = val;
  }
}
