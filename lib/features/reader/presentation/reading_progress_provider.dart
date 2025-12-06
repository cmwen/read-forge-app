import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_forge/core/providers/database_provider.dart';

/// Provider for reading progress state
final readingProgressProvider =
    StateNotifierProvider.family<
      ReadingProgressNotifier,
      ReadingProgressState,
      ReadingProgressParams
    >(
      (ref, params) =>
          ReadingProgressNotifier(ref.watch(bookRepositoryProvider), params),
    );

/// Parameters for reading progress
class ReadingProgressParams {
  final int bookId;
  final int chapterId;

  const ReadingProgressParams({required this.bookId, required this.chapterId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingProgressParams &&
          runtimeType == other.runtimeType &&
          bookId == other.bookId &&
          chapterId == other.chapterId;

  @override
  int get hashCode => bookId.hashCode ^ chapterId.hashCode;
}

/// Reading progress state
class ReadingProgressState {
  final ScrollController scrollController;
  final int currentPosition;
  final double percentComplete;
  final bool isLoading;

  ReadingProgressState({
    required this.scrollController,
    this.currentPosition = 0,
    this.percentComplete = 0.0,
    this.isLoading = false,
  });

  ReadingProgressState copyWith({
    ScrollController? scrollController,
    int? currentPosition,
    double? percentComplete,
    bool? isLoading,
  }) {
    return ReadingProgressState(
      scrollController: scrollController ?? this.scrollController,
      currentPosition: currentPosition ?? this.currentPosition,
      percentComplete: percentComplete ?? this.percentComplete,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier for managing reading progress
class ReadingProgressNotifier extends StateNotifier<ReadingProgressState>
    with WidgetsBindingObserver {
  final dynamic _repository;
  final ReadingProgressParams _params;
  bool _initialized = false;

  ReadingProgressNotifier(this._repository, this._params)
    : super(ReadingProgressState(scrollController: ScrollController())) {
    _init();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _init() async {
    if (_initialized) return;
    _initialized = true;

    // Load saved progress
    final progress = await _repository.getReadingProgress(_params.bookId);
    if (progress != null &&
        progress.lastChapterId == _params.chapterId &&
        progress.lastPosition > 0) {
      state = state.copyWith(
        currentPosition: progress.lastPosition,
        percentComplete: progress.percentComplete,
      );

      // Schedule scroll to saved position after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state.scrollController.hasClients) {
          final maxScroll = state.scrollController.position.maxScrollExtent;
          final targetPosition = (progress.lastPosition / 1000.0 * maxScroll)
              .clamp(0.0, maxScroll);
          state.scrollController.animateTo(
            targetPosition,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }

    // Listen to scroll changes
    state.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!state.scrollController.hasClients) return;

    final position = state.scrollController.position;
    final scrollPosition = position.pixels;
    final maxScroll = position.maxScrollExtent;

    // Convert scroll position to a normalized value (0-1000 for precision)
    final normalizedPosition = maxScroll > 0
        ? (scrollPosition / maxScroll * 1000).round()
        : 0;

    if (normalizedPosition != state.currentPosition) {
      state = state.copyWith(currentPosition: normalizedPosition);
    }
  }

  /// Save current reading progress
  Future<void> saveProgress() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    try {
      final percentComplete = await _repository.calculateReadingProgress(
        _params.bookId,
        _params.chapterId,
        state.currentPosition,
      );

      await _repository.updateReadingProgress(
        bookId: _params.bookId,
        lastChapterId: _params.chapterId,
        lastPosition: state.currentPosition,
        percentComplete: percentComplete,
      );

      state = state.copyWith(
        percentComplete: percentComplete,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // App is going to background, save progress
      saveProgress();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    state.scrollController.removeListener(_onScroll);
    state.scrollController.dispose();
    super.dispose();
  }
}
