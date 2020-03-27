

class AppSettings {
  bool _isDark = true;

  setDarkMode(val) {
    _isDark = val;
  }

  isDark() {
    return _isDark;
  }
}
