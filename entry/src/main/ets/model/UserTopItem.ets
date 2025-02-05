import { Artist } from './Artist'
import { Track } from './Track'

export class TopItemsRequest {
  type: 'artists' | 'tracks'
  time_range?: 'long_term' | 'medium_term' | 'short_term'
  limit?: number
  offset?: number

  constructor(
    type: 'artists' | 'tracks' = 'artists',
    time_range: 'long_term' | 'medium_term' | 'short_term' = 'medium_term',
    limit: number,
    offset: number
  ) {
    this.type = type;
    this.time_range = time_range;
    this.limit = limit
    this.offset = offset
  }
}


export class TopItems {
  href: string
  limit: number
  next: string | null
  offset: number
  previous: string | null
  total: number
  items: Artist[] | Track[]

  constructor(href: string, limit: number, next: string | null, offset: number, previous: string | null, total: number, items: Artist[] | Track[]) {
    this.href = href
    this.limit = limit
    this.next = next
    this.offset = offset
    this.previous = previous
    this.total = total
    this.items = items
  }
}
