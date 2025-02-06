import { Cursors, ExternalUrls } from './Artist'
import { Track } from '../model/Track'

export class RecentPlayedTracks {
  href: string
  limit: number
  next: string
  cursors: Cursors
  total: number
  items: PlayHistory[]

  constructor(href: string, limit: number, next: string, cursors: Cursors, total: number, items: PlayHistory[]) {
    this.href = href
    this.limit = limit
    this.next = next
    this.cursors = cursors
    this.total = total
    this.items = items
  }
}

export class PlayHistory {
  track: Track
  played_at: string
  context: Context

  constructor(track: Track, played_at: string, context: Context) {
    this.track = track
    this.played_at = played_at
    this.context = context
  }
}

export class Context {
  type: string
  href: string
  external_urls: ExternalUrls
  uri: string

  constructor(type: string, href: string, external_urls: ExternalUrls, uri: string) {
    this.type = type
    this.href = href
    this.external_urls = external_urls
    this.uri = uri
  }
}