import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/track_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/playlist_providers.dart';
import 'create_playlist_dialog.dart';

class AddToPlaylistSheet extends ConsumerWidget {
  const AddToPlaylistSheet({super.key, required this.track});

  final TrackModel track;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistsAsync = ref.watch(playlistsProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.gray6,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray4,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Simpan ke Playlist',
                      style: AppTextStyles.title.copyWith(fontSize: 16)),
                  // Tombol buat playlist baru
                  TextButton.icon(
                    onPressed: () => _createNewPlaylist(context, ref),
                    icon: const Icon(Icons.add, color: AppColors.green1),
                    label: const Text('Baru',
                        style: TextStyle(color: AppColors.green1)),
                  ),
                ],
              ),
            ),

            const Divider(color: AppColors.gray5),

            // List playlist
            playlistsAsync.when(
              data: (playlists) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: playlists.length,
                itemBuilder: (_, index) {
                  final playlist = playlists[index];
                  final isDefault = playlist['is_default'] as bool? ?? false;

                  return ListTile(
                    leading: Icon(
                      isDefault
                          ? Icons.favorite
                          : Icons.queue_music_rounded,
                      color: isDefault ? AppColors.green1 : AppColors.gray3,
                    ),
                    title: Text(
                      playlist['name'] as String,
                      style: const TextStyle(color: AppColors.gray1),
                    ),
                    onTap: () async {
                      await ref
                          .read(playlistActionsProvider.notifier)
                          .addTrackToPlaylist(
                            playlistId: playlist['id'] as String,
                            track: track,
                          );
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Ditambahkan ke ${playlist['name']}',
                            ),
                            backgroundColor: AppColors.green3,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: AppColors.green1),
              ),
              error: (_, _) => const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Gagal memuat playlist',
                  style: TextStyle(color: AppColors.gray4),
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _createNewPlaylist(
    BuildContext context, WidgetRef ref) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const CreatePlaylistDialog(),
    );
    if (name == null || name.isEmpty) return;
    await ref.read(playlistActionsProvider.notifier).createPlaylist(name);
  }
}