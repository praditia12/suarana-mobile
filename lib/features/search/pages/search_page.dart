import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/music/track_tile.dart';
import '../../../features/player/providers/player_provider.dart';
import '../providers/search_providers.dart';
import '../widgets/search_bar_field.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: SearchBarField(
          controller: _controller,
          onChanged: (query) =>
              ref.read(searchProvider.notifier).onQueryChanged(query),
          onClear: () => ref.read(searchProvider.notifier).clearSearch(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: _buildBody(searchState),
        ),
      ),
    );
  }

  Widget _buildBody(SearchState state) {
    return switch (state.status) {
      SearchStatus.idle    => const _IdleView(),
      SearchStatus.loading => const _LoadingView(),
      SearchStatus.empty   => const _EmptyView(),
      SearchStatus.error   => _ErrorView(state: state),
      SearchStatus.success => _ResultList(
          tracks: state.results,
          onTap: (index) {
            ref.read(playerProvider.notifier).playFromQueue(
                  queue: state.results,
                  index: index,
                );
          },
        ),
    };
  }
}

// ─── Views — masing-masing di file widgets/ idealnya,
//     tapi karena hanya dipakai di search page, cukup di sini
//     sesuai prinsip: extract kalau reusable lintas feature ───────────────────

class _IdleView extends StatelessWidget {
  const _IdleView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: AppColors.gray5),
          SizedBox(height: 16),
          Text(
            'Cari lagu atau artis favoritmu',
            style: TextStyle(color: AppColors.gray4),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.green1),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_off, size: 64, color: AppColors.gray5),
          SizedBox(height: 16),
          Text(
            'Lagu tidak ditemukan',
            style: TextStyle(color: AppColors.gray4),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.state});
  final SearchState state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            state.isNoInternet
                ? Icons.wifi_off_rounded
                : Icons.error_outline_rounded,
            size: 64,
            color: AppColors.gray5,
          ),
          const SizedBox(height: 16),
          Text(
            state.errorMessage ?? 'Terjadi kesalahan',
            style: const TextStyle(color: AppColors.gray4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.tracks, required this.onTap});
  final List tracks;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tracks.length,
      itemBuilder: (_, index) {
        final track = tracks[index];
        return TrackTile(
          title: track.title,
          artistName: track.artistName,
          artworkUrl: track.artworkUrl,
          onTap: () => onTap(index),
        );
      },
    );
  }
}