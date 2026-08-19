import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/playlist_providers.dart';
import '../widgets/create_playlist_dialog.dart';
import '../widgets/playlist_card.dart';
import 'playlist_detail_page.dart';

class PlaylistPage extends ConsumerWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Playlist Kamu', style: AppTextStyles.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.gray1),
            onPressed: () => _createPlaylist(context, ref),
          ),
        ],
      ),
      body: playlistsAsync.when(
        data: (playlists) => playlists.isEmpty
            ? _EmptyView(onCreateTap: () => _createPlaylist(context, ref))
            : RefreshIndicator(
                color: AppColors.green1,
                onRefresh: () async => ref.invalidate(playlistsProvider),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: playlists.length,
                  separatorBuilder: (_, _) =>
                      const Divider(color: AppColors.gray6, height: 1),
                  itemBuilder: (_, index) {
                    final playlist = playlists[index];
                    final isDefault =
                        playlist['is_default'] as bool? ?? false;

                    return PlaylistCard(
                      name: playlist['name'] as String,
                      trackCount: playlist['track_count'] as int? ?? 0,
                      isDefault: isDefault,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PlaylistDetailPage(
                            playlistId: playlist['id'] as String,
                            playlistName: playlist['name'] as String,
                            isDefault: isDefault,
                          ),
                        ),
                      ),
                      onDelete: isDefault
                          ? null
                          : () => _confirmDelete(
                                context,
                                ref,
                                playlist['id'] as String,
                                playlist['name'] as String,
                              ),
                    );
                  },
                ),
              ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.green1),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.gray4, size: 48),
              const SizedBox(height: 12),
              const Text('Gagal memuat playlist',
                  style: TextStyle(color: AppColors.gray3)),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => ref.invalidate(playlistsProvider),
                child: const Text('Coba lagi',
                    style: TextStyle(color: AppColors.green1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createPlaylist(BuildContext context, WidgetRef ref) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const CreatePlaylistDialog(),
    );
    if (name == null || name.isEmpty) return;
    await ref.read(playlistActionsProvider.notifier).createPlaylist(name);
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String playlistId,
    String name,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.gray6,
        title: const Text('Hapus Playlist',
            style: TextStyle(color: AppColors.gray1)),
        content: Text('Hapus playlist "$name"?',
            style: const TextStyle(color: AppColors.gray3)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal',
                style: TextStyle(color: AppColors.gray3)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref
          .read(playlistActionsProvider.notifier)
          .deletePlaylist(playlistId);
    }
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onCreateTap});
  final VoidCallback onCreateTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.queue_music_rounded,
              size: 64, color: AppColors.gray5),
          const SizedBox(height: 16),
          const Text('Belum ada playlist',
              style: TextStyle(color: AppColors.gray3)),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onCreateTap,
            child: const Text('Buat Playlist',
                style: TextStyle(color: AppColors.green1)),
          ),
        ],
      ),
    );
  }
}