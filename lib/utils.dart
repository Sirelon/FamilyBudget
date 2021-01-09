extension MyList<T> on List<T> {
  T get firstOrNull => this.isEmpty ? null : this.first;
}
