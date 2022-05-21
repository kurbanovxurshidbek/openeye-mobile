 class ReadingAudioBookState {
  bool isLoading;
  double? currentPosition;
  double? duration;
  bool? isPlaying;
  bool isFamale;

  ReadingAudioBookState(
      {required this.isLoading, this.currentPosition, this.duration, this.isPlaying,required this.isFamale});
}
