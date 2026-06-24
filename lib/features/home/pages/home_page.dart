import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/home_providers.dart';
import '../sections/popular_albums_section.dart';
import '../sections/popular_gendres_section.dart';
import '../sections/trending_songs_section.dart';
import '../widgets/home_app_bar.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAsync = ref.watch(trendingTracksProvider);
    final albumsAsync = ref.watch(popularAlbumsProvider);
    final genreAsync = ref.watch(popularGenreProvider);

    final isLoading = trendingAsync.isLoading ||
        albumsAsync.isLoading ||
        genreAsync.isLoading;

    final error = trendingAsync.error ?? albumsAsync.error ?? genreAsync.error;

    return Scaffold(
      appBar: const HomeAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.background,
          onRefresh: () async {
            ref.invalidate(trendingTracksProvider);
            ref.invalidate(popularAlbumsProvider);
            ref.invalidate(popularGenreProvider);

            // try-catch menghindari uncaught dan loading spinner tidak pernah berhenti.
            try {
              await Future.wait([
                ref.read(trendingTracksProvider.future),
                ref.read(popularAlbumsProvider.future),
                ref.read(popularGenreProvider.future),
              ]);
            } catch (_) {
              // sudah di handle errorView
            }
          },
          child: isLoading
              ? const _LoadingView()
              : error != null
                  ? _ErrorView(error: error)
                  : _ContentView(
                      trendingAsync: trendingAsync,
                      albumsAsync: albumsAsync,
                      genreAsync: genreAsync,
                    ),
        ),
      ),
    );
  }
}

class _ContentView extends StatelessWidget {
  const _ContentView({
    required this.trendingAsync,
    required this.albumsAsync,
    required this.genreAsync,
  });

  final AsyncValue trendingAsync;
  final AsyncValue albumsAsync;
  final AsyncValue genreAsync;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        child: Column(
          spacing: AppSpacing.md,
          children: [
            PopularAlbumsSection(albums: albumsAsync.value!),
            TrendingSongsSection(tracks: trendingAsync.value!),
            PopularGenresSection(genres: genreAsync.value!),
          ],
        ),
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});

  final Object error;

  bool _isNoInternet(Object error) {
    if (error is SocketException) return true;
    // ClientException muncul saat koneksi putus di tengah request
    if (error is Exception && error.toString().contains('SocketException')) {
      return true;
    }
    // Timeout — koneksi ada tapi sangat lambat atau server tidak respon
    if (error is TimeoutException) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isNoInternet = _isNoInternet(error);

    final icon = isNoInternet
        ? Icons.wifi_off_rounded
        : Icons.error_outline_rounded;
    final title = isNoInternet ? 'Tidak ada koneksi' : 'Terjadi kesalahan';
    final message = isNoInternet
        ? 'Periksa koneksi internet kamu,\nlalu tarik layar ke bawah untuk memuat ulang.'
        : 'Gagal memuat data dari server.\nTarik layar ke bawah untuk mencoba lagi.';

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 52, color: AppColors.gray4),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.gray2,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.gray4,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}