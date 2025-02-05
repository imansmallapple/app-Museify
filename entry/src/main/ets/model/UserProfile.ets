import image from '@ohos.multimedia.image';

export class ExplicitContent {
  filterEnabled: boolean;
  filterLocked: boolean;

  constructor(filterEnabled: boolean, filterLocked: boolean) {
    this.filterEnabled = filterEnabled;
    this.filterLocked = filterLocked;
  }
}

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
  url: string;
  height: number;
  width: number;

  constructor(url: string, height: number, width: number) {
    this.url = url;
    this.height = height;
    this.width = width;
  }
}

export class CurrentUserProfile {
  country: string
  display_name: string
  email: string
  explicit_content: ExplicitContent
  external_urls: ExternalUrls
  followers: Followers
  href: string
  id: string
  images: Image[]
  product: string
  type: string
  uri: string

  constructor(
    country: string,
    displayName: string,
    email: string,
    explicitContent: ExplicitContent,
    externalUrls: ExternalUrls,
    followers: Followers,
    href: string,
    id: string,
    images: Image[],
    product: string,
    type: string,
    uri: string
  ) {
    this.country = country;
    this.display_name = displayName;
    this.email = email;
    this.explicit_content = explicitContent;
    this.external_urls = externalUrls;
    this.followers = followers;
    this.href = href;
    this.id = id;
    this.images = images;
    this.product = product;
    this.type = type;
    this.uri = uri;
  }
}

export class PublicUserProfile {
  display_name: string | null
  external_urls: ExternalUrls
  followers: Followers
  href: string
  id: string
  images: Image[]
  type: string = 'user'
  uri: string

  constructor(displayName: string | null, external_urls: ExternalUrls, followers: Followers, href: string, id: string, images: Image[], uri: string) {
    this.display_name = displayName
    this.external_urls = external_urls
    this.followers = followers
    this.href = href
    this.id = id
    this.images = images
    this.uri = uri
  }
}