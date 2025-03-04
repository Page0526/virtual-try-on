class NavigationProvider {
  int _selectedIndex = 0; 

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
    }
  }
}