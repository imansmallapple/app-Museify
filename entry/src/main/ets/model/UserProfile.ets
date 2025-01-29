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

export class UserProfile {
  country: string;
  displayName: string;
  email: string;
  explicitContent: ExplicitContent;
  externalUrls: ExternalUrls;
  followers: Followers;
  href: string;
  id: string;
  images: Image[];
  product: string;
  type: string;
  uri: string;

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
    this.displayName = displayName;
    this.email = email;
    this.explicitContent = explicitContent;
    this.externalUrls = externalUrls;
    this.followers = followers;
    this.href = href;
    this.id = id;
    this.images = images;
    this.product = product;
    this.type = type;
    this.uri = uri;
  }
}
