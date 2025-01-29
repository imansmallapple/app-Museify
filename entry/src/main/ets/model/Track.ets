export class ExternalUrls {
  spotify: string;

  constructor(spotify: string) {
    this.spotify = spotify;
  }
}

export class Image {
  url: string;
  height: number;
  width: number;

  constructor(url: string, height: number, width: number) {
    this.url = url;
    this.height = height;
    this.width = width;
  }
}

export class Artist {
  externalUrls: ExternalUrls;
  href: string;
  id: string;
  name: string;
  type: string;
  uri: string;

  constructor(externalUrls: ExternalUrls, href: string, id: string, name: string, type: string, uri: string) {
    this.externalUrls = externalUrls;
    this.href = href;
    this.id = id;
    this.name = name;
    this.type = type;
    this.uri = uri;
  }
}

export class Album {
  albumType: string;
  totalTracks: number;
  externalUrls: ExternalUrls;
  href: string;
  id: string;
  images: Image[];
  name: string;
  releaseDate: string;
  releaseDatePrecision: string;
  type: string;
  uri: string;
  artists: Artist[];
  isPlayable: boolean;

  constructor(
    albumType: string,
    totalTracks: number,
    externalUrls: ExternalUrls,
    href: string,
    id: string,
    images: Image[],
    name: string,
    releaseDate: string,
    releaseDatePrecision: string,
    type: string,
    uri: string,
    artists: Artist[],
    isPlayable: boolean
  ) {
    this.albumType = albumType;
    this.totalTracks = totalTracks;
    this.externalUrls = externalUrls;
    this.href = href;
    this.id = id;
    this.images = images;
    this.name = name;
    this.releaseDate = releaseDate;
    this.releaseDatePrecision = releaseDatePrecision;
    this.type = type;
    this.uri = uri;
    this.artists = artists;
    this.isPlayable = isPlayable;
  }
}

export class ExternalIds {
  isrc: string;

  constructor(isrc: string) {
    this.isrc = isrc;
  }
}

export class LinkedFrom {
  externalUrls: ExternalUrls;
  href: string;
  id: string;
  type: string;
  uri: string;

  constructor(externalUrls: ExternalUrls, href: string, id: string, type: string, uri: string) {
    this.externalUrls = externalUrls;
    this.href = href;
    this.id = id;
    this.type = type;
    this.uri = uri;
  }
}

export class Track {
  album: Album;
  artists: Artist[];
  discNumber: number;
  durationMs: number;
  explicit: boolean;
  externalIds: ExternalIds;
  externalUrls: ExternalUrls;
  href: string;
  id: string;
  isPlayable: boolean;
  linkedFrom: LinkedFrom;
  name: string;
  popularity: number;
  previewUrl: string | null;
  trackNumber: number;
  type: string;
  uri: string;
  isLocal: boolean;

  constructor(
    album: Album,
    artists: Artist[],
    discNumber: number,
    durationMs: number,
    explicit: boolean,
    externalIds: ExternalIds,
    externalUrls: ExternalUrls,
    href: string,
    id: string,
    isPlayable: boolean,
    linkedFrom: LinkedFrom,
    name: string,
    popularity: number,
    previewUrl: string | null,
    trackNumber: number,
    type: string,
    uri: string,
    isLocal: boolean
  ) {
    this.album = album;
    this.artists = artists;
    this.discNumber = discNumber;
    this.durationMs = durationMs;
    this.explicit = explicit;
    this.externalIds = externalIds;
    this.externalUrls = externalUrls;
    this.href = href;
    this.id = id;
    this.isPlayable = isPlayable;
    this.linkedFrom = linkedFrom;
    this.name = name;
    this.popularity = popularity;
    this.previewUrl = previewUrl;
    this.trackNumber = trackNumber;
    this.type = type;
    this.uri = uri;
    this.isLocal = isLocal;
  }
}
