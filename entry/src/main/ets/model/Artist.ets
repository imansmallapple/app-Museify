import { Track } from '../model/Track'

export class ExternalUrls {
  spotify: string;

  constructor(spotify: string) {
    this.spotify = spotify;
  }
}

export class Followers {
  href: string | null;
  total: number;

  constructor(href: string | null, total: number) {
    this.href = href;
    this.total = total;
  }
}

export class Image {
  height: number;
  url: string;
  width: number;

  constructor(height: number, url: string, width: number) {
    this.height = height;
    this.url = url;
    this.width = width;
  }
}

export class Artist {
  external_urls: ExternalUrls;
  followers: Followers;
  genres: string[];
  href: string;
  id: string;
  images: Image[];
  name: string;
  popularity: number;
  type: string;
  uri: string;

  constructor(
    external_urls: ExternalUrls,
    followers: Followers,
    genres: string[],
    href: string,
    id: string,
    images: Image[],
    name: string,
    popularity: number,
    type: string,
    uri: string
  ) {
    this.external_urls = external_urls;
    this.followers = followers;
    this.genres = genres;
    this.href = href;
    this.id = id;
    this.images = images;
    this.name = name;
    this.popularity = popularity;
    this.type = type;
    this.uri = uri;
  }
}

export class FollowedArtists {
  href: string
  limit: number
  next: string
  cursors: Cursors
  total: number
  items: Artist[]

  constructor(href: string, limit: number, next: string, cursors: Cursors, total: number, items: Artist[]) {
    this.href = href
    this.limit = limit
    this.next = next
    this.cursors = cursors
    this.total = total
    this.items = items
  }
}

export class Cursors {
  after: string
  before: string

  constructor(after: string, before: string) {
    this.after = after
    this.before = before
  }
}

export class ArtistTopTracks {
  tracks: Track[]

  constructor(tracks: Track[]) {
    this.tracks = tracks
  }
}
