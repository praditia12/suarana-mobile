import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../services/profile_picture_service.dart';
import '../../auth/providers/auth_provider.dart';

// Profile Picture
class ProfilePictureNotifier extends AsyncNotifier<String?> {
  final _service = ProfilePictureService();
  final _picker = ImagePicker();

  @override
  Future<String?> build() async {
    // Load path foto dari local storage saat pertama kali
    return _service.loadPath();
  }

  Future<void> pickFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (image == null) return;
    await _service.savePath(image.path);
    state = AsyncData(image.path);
  }

  Future<void> pickFromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (image == null) return;
    await _service.savePath(image.path);
    state = AsyncData(image.path);
  }

  Future<void> removePhoto() async {
    await _service.clearPath();
    state = const AsyncData(null);
  }
}

final profilePictureProvider =
    AsyncNotifierProvider<ProfilePictureNotifier, String?>(
  ProfilePictureNotifier.new,
);

// Profile Data dari Supabase 
final profileDataProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) return null;

  final response = await client
      .from('profiles')
      .select()
      .eq('id', user.id)
      .single();

  return response;
});