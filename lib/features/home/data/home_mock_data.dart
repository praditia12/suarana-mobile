import '../../../core/models/album_model.dart';
import '../models/gendre_model.dart';
import '../../../core/models/track_model.dart';

const demoAlbums = [
  AlbumModel(
    id: '1',
    title: 'Memorandum',
    artistName: 'Perunggu',
    artworkUrl: 'https://picsum.photos/90',
  ),
  AlbumModel(
    id: '2',
    title: 'Galura Tropikalia',
    artistName: 'The Panturas',
    artworkUrl: 'https://picsum.photos/100',
  ),
  AlbumModel(
    id: '3',
    title: 'Lagipula Hidup Akan Berakhir',
    artistName: 'Hindia',
    artworkUrl: 'https://picsum.photos/155',
  ),
  AlbumModel(
    id: '4',
    title: 'Sheila on 7',
    artistName: 'Sheila on 7',
    artworkUrl: 'https://picsum.photos/177',
  ),
];

const demoTracks = [
  TrackModel(
    id: '1',
    title: 'Film Favorit',
    artistName: 'Sheila on 7',
    artworkUrl: 'https://picsum.photos/167',
  ),
  TrackModel(
    id: '2',
    title: 'Bentang Sagara',
    artistName: 'The Panturas',
    artworkUrl: 'https://picsum.photos/85',
  ),
  TrackModel(
    id: '3',
    title: 'Ini Abadi',
    artistName: 'Perunggu',
    artworkUrl: 'https://picsum.photos/94',
  ),
  TrackModel(
    id: '4',
    title: 'Kita',
    artistName: 'Sheila on 7',
    artworkUrl: 'https://picsum.photos/93',
  ),
];

const demoGenres = [
  GendreModel(id: '1', title: 'Indo Pop'),
  GendreModel(id: '2', title: 'HipHop'),
  GendreModel(id: '3', title: 'Rock'),
  GendreModel(id: '4', title: 'Indie'),
];