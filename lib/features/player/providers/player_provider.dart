import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/models/track_model.dart';

class PlayerState {
  final TrackModel? currentTrack;
  final List<TrackModel> queue;
  final int currentIndex;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool isLoading;
  final String? error;

  const PlayerState({
    this.currentTrack,
    this.queue = const [],
    this.currentIndex = 0,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isLoading = false,
    this.error,
  });

  bool get hasTrack => currentTrack != null;
  bool get hasPrevious => currentIndex > 0;
  bool get hasNext => currentIndex < queue.length - 1;

  PlayerState copyWith({
    TrackModel? currentTrack,
    List<TrackModel>? queue,
    int? currentIndex,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? isLoading,
    String? error,
  }) {
    return PlayerState(
      currentTrack: currentTrack ?? this.currentTrack,
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PlayerNotifier extends Notifier<PlayerState> {
  late final AudioPlayer _audio;
  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _playingSub;
  StreamSubscription? _processingStateSub;

  @override
  PlayerState build() {
    _audio = AudioPlayer();
    _initListeners();

    ref.onDispose(() {
      _positionSub?.cancel();
      _durationSub?.cancel();
      _playingSub?.cancel();
      _processingStateSub?.cancel();
      _audio.dispose();
    });

    return const PlayerState();
  }

  void _initListeners() {
    _positionSub = _audio.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });

    _durationSub = _audio.durationStream.listen((dur) {
      if (dur != null) state = state.copyWith(duration: dur);
    });

    _playingSub = _audio.playingStream.listen((playing) {
      state = state.copyWith(isPlaying: playing);
    });

    _processingStateSub = _audio.processingStateStream.listen((ps) {
      final isLoading = ps == ProcessingState.loading ||
          ps == ProcessingState.buffering;

      state = state.copyWith(isLoading: isLoading);

      // Auto next saat track selesai
      if (ps == ProcessingState.completed) {
        next();
      }
    });
  }

  Future<void> playFromQueue({
    required List<TrackModel> queue,
    required int index,
  }) async {
    state = state.copyWith(
      queue: queue,
      currentIndex: index,
      currentTrack: queue[index],
      position: Duration.zero,
      error: null,
    );

    await _loadAndPlay(queue[index]);
  }

  Future<void> _loadAndPlay(TrackModel track) async {
    try {
      await _audio.stop();
      await _audio.setUrl(track.streamUrl);
      await _audio.play();
    } catch (e) {
      state = state.copyWith(
        isPlaying: false,
        isLoading: false,
        error: 'Gagal memutar lagu. Coba lagi.',
      );
    }
  }

  Future<void> togglePlayPause() async {
    if (_audio.playing) {
      await _audio.pause();
    } else {
      await _audio.play();
    }
  }

  Future<void> seek(Duration position) async {
    await _audio.seek(position);
  }

  Future<void> next() async {
    if (!state.hasNext) return;
    final nextIndex = state.currentIndex + 1;
    final nextTrack = state.queue[nextIndex];

    state = state.copyWith(
      currentIndex: nextIndex,
      currentTrack: nextTrack,
      position: Duration.zero,
      error: null,
    );

    await _loadAndPlay(nextTrack);
  }

  Future<void> previous() async {
    if (state.position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }

    if (!state.hasPrevious) return;
    final prevIndex = state.currentIndex - 1;
    final prevTrack = state.queue[prevIndex];

    state = state.copyWith(
      currentIndex: prevIndex,
      currentTrack: prevTrack,
      position: Duration.zero,
      error: null,
    );

    await _loadAndPlay(prevTrack);
  }

  Future<void> stop() async {
    await _audio.stop();
    state = const PlayerState();
  }
}

final playerProvider = NotifierProvider<PlayerNotifier, PlayerState>(
  PlayerNotifier.new,
);