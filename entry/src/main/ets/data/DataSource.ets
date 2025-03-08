import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';
import { Artist, ArtistTopTracks, FollowedArtists } from '../model/Artist';
import { Track } from '../model/Track'
import { CurrentUserProfile, PublicUserProfile } from '../model/UserProfile'
import { UserAuthorizeAccepted, UserAuthorizeDenied } from '../model/UserAuthorization';
import { Log } from '../utils/Log';
import { TopItems } from '../model/UserTopItem';
import { RecentPlayedTracks } from '../model/Play';

const BASE_URL = "https://accounts.spotify.com"
let state: string = '1234567890123456';
const scope: string = 'user-read-private user-read-email';
const requestToken = BASE_URL + "/api/token"

const getArtistData = BASE_URL + 'v1/artists/4Z8W4fKeB5YxbusRsdQVPb'

const client_id = "3b890116acda47138418a110a37334bd"
const client_secret = "db08fe193213403bbab5dcd264abf1f6"
const redirect_uri = "https://developer.spotify.com/"
const api_url = "https://api.spotify.com/v1"

class AccessToken {
  access_token!: string
  token_type!: string
  expires_in!: number
}

class DataSource {
  constructor() {
  }

  // todo: make it private later
  async requestAccessToken(): Promise<AccessToken> {
    return new Promise<AccessToken>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(requestToken,
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          expectDataType: http.HttpDataType.STRING,
          extraData: `grant_type=client_credentials&client_id=${client_id}&client_secret=${client_secret}`,
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            try {
              let responseData: AccessToken = JSON.parse(data.result as string)
              resolve(responseData)
            } catch (error) {
              reject('Failed to parse response data')
            }
            finally {
              httpRequest.off('headersReceive');
              httpRequest.destroy();
            }
          } else {
            reject('Error: ' + err)
          }
        })
    })
  }

  async getArtistData(access_token: string): Promise<Artist> {

    // todo: Replace url with changable id
    // let access_token: string = (await this.requestAccessToken()).access_token

    return new Promise<Artist>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request("https://api.spotify.com/v1/artists/4Z8W4fKeB5YxbusRsdQVPb",
        {
          method: http.RequestMethod.GET,
          header: {
            Authorization: `Bearer ${access_token}`
          },
          expectDataType: http.HttpDataType.STRING,
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            try {
              let responseData: Artist = JSON.parse(data.result as string)
              resolve(responseData)
            } catch (error) {
              reject('Failed to parse response data')
            }
            finally {
              httpRequest.off('headersReceive');
              httpRequest.destroy();
            }
          } else {
            reject('Error: ' + err)
          }
        })
    })
  }

  async fetchHttpCode(): Promise<number> {
    try {
      let httpRequest = http.createHttp();
      const response = await new Promise<number>((resolve, reject) => {
        httpRequest.request(BASE_URL, (err: Error, data: http.HttpResponse) => {
          if (!err) {
            resolve(data.responseCode);
          } else {
            reject(err);
          }
        });
      });
      return response;
    } catch (error) {
      console.error('Error fetching HTTP code:', error);
      return -1;
    }
  }

  async getTrack(access_token: string): Promise<Track> {
    // todo: Replace url with changable id
    return new Promise<Track>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request("https://api.spotify.com/v1/tracks/11dFghVXANMlKmJXsNCbNl?market=PL",
        {
          method: http.RequestMethod.GET,
          header: {
            Authorization: `Bearer ${access_token}`
          },
          expectDataType: http.HttpDataType.STRING,
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            try {
              let responseData: Track = JSON.parse(data.result as string)
              resolve(responseData)
            } catch (error) {
              reject('Failed to parse response data')
            }
            finally {
              httpRequest.off('headersReceive');
              httpRequest.destroy();
            }
          } else {
            reject('Error: ' + err)
          }
        })
    })
  }

  // User
  async getCurrentUserProfile(access_token: string): Promise<CurrentUserProfile> {
    return new Promise<CurrentUserProfile>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request("https://api.spotify.com/v1/me",
        {
          method: http.RequestMethod.GET,
          header: {
            Authorization: `Bearer ${access_token}`
          },
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            try {
              let responseData: CurrentUserProfile = JSON.parse(data.result as string)
              Log.info('User Profile', 'responseData', responseData)
              resolve(responseData)
            } catch (error) {
              Log.error('User Profile', error)
              reject('Failed to parse response data')
            }
            finally {
              httpRequest.off('headersReceive');
              httpRequest.destroy();
            }
          } else {
            Log.error('User Profile', err.message)
            reject('Error: ' + err)
          }
        })
    })
  }

  async getUserTopItems(access_token: string, type: string, time_range?: string, limit?: number, offset?: number): Promise<TopItems> {
    return new Promise<TopItems>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(api_url + `/me/top/${type}`,
        {
          method: http.RequestMethod.GET,
          header: {
            Authorization: `Bearer ${access_token}`
          },
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            try {
              let responseData: TopItems = JSON.parse(data.result as string)
              Log.info('User Top Items', 'responseData', responseData)
              resolve(responseData)
            } catch (error) {
              Log.error('User Top Items', error)
              reject('Failed to parse response data')
            }
            finally {
              httpRequest.off('headersReceive');
              httpRequest.destroy();
            }
          } else {
            Log.error('User Top Items', err.message)
            reject('Error: ' + err)
          }
        })
    })
  }

  async login(): Promise<UserAuthorizeAccepted | UserAuthorizeDenied> {
    return new Promise<UserAuthorizeAccepted | UserAuthorizeDenied>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request("https://accounts.spotify.com/authorize?" +
      JSON.stringify({
        response_type: 'code',
        client_id: client_id,
        scope: scope,
        redirect_uri: redirect_uri,
        state: state
      })
        ,
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            try {
              let responseData: UserAuthorizeAccepted | UserAuthorizeDenied = JSON.parse(data.result as string)
              resolve(responseData)
            } catch (error) {
              reject('Failed to parse response data')
            }
            finally {
              httpRequest.off('headersReceive');
              httpRequest.destroy();
            }
          } else {
            reject('Error: ' + err)
          }
        })
    })
  }

  async getPublicUserProfile(access_token: string, user_id: string): Promise<PublicUserProfile> {
    return new Promise<PublicUserProfile>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(api_url + `/users/${user_id}`,
        {
          method: http.RequestMethod.GET,
          header: {
            Authorization: `Bearer ${access_token}`
          },
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            try {
              let responseData: PublicUserProfile = JSON.parse(data.result as string)
              Log.info('User Top Items', 'responseData', responseData)
              resolve(responseData)
            } catch (error) {
              Log.error('User Top Items', error)
              reject('Failed to parse response data')
            }
            finally {
              httpRequest.off('headersReceive');
              httpRequest.destroy();
            }
          } else {
            Log.error('User Top Items', err.message)
            reject('Error: ' + err)
          }
        })
    })
  }

  async followPlaylist(access_token: string, playlist_id: string): Promise<boolean> {
    return new Promise<boolean>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(api_url + `/playlists/${playlist_id}/followers`,
        {
          method: http.RequestMethod.PUT,
          header: {
            Authorization: `Bearer ${access_token}`,
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify({ public: false }),
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            Log.info('Follow Playlist', 'responseCode', data.responseCode);
            if (data.responseCode === 200) {
              Log.info('Follow Playlist', 'Successfully followed playlist');
              resolve(true)
            } else {
              Log.error('Follow Playlist', `Unexpected response: ${data.responseCode}`);
              reject(`Unexpected response: ${data.responseCode}`);
            }
          }
          else {
            Log.error('Follow Playlist', err.message)
            reject('Error: ' + err)
          }
        })
    })
  }

  async unfollowPlaylist(access_token: string, playlist_id: string): Promise<boolean> {
    return new Promise<boolean>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(api_url + `/playlists/${playlist_id}/followers`,
        {
          method: http.RequestMethod.DELETE,
          header: {
            Authorization: `Bearer ${access_token}`,
          },
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            if (data.responseCode === 200) {
              Log.info('Unfollow Playlist', 'Successfully unfollowed playlist');
              resolve(true)
            } else {
              Log.error('Unfollow Playlist', `Unexpected response: ${data.responseCode}`);
              reject(`Unexpected response: ${data.responseCode}`);
            }
          }
          else {
            Log.error('Follow Playlist', err.message)
            reject('Error: ' + err)
          }
        })
    })
  }

  async getFollowedArtists(access_token: string): Promise<FollowedArtists> {
    return new Promise<FollowedArtists>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(api_url + '/me/following?type=artist',
        {
          method: http.RequestMethod.GET,
          header: {
            Authorization: `Bearer ${access_token}`,
          },
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            try {
              let responseData: FollowedArtists = JSON.parse(data.result as string)
              Log.info('User Followed Artists', 'responseData', responseData)
              resolve(responseData)
            } catch (error) {
              Log.error('User Followed Artists', error)
              reject('Failed to parse response data')
            }
            finally {
              httpRequest.off('headersReceive');
              httpRequest.destroy();
            }
          }
          else {
            Log.error('User Followed Artists', err.message)
            reject('Error: ' + err)
          }
        })
    })
  }

  async followArtistsOrUsers(access_token: string, type: string, ids: string): Promise<boolean> {
    return new Promise<boolean>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(api_url + '/me/following' + `?type=${type}&ids=${ids}`,
        {
          method: http.RequestMethod.PUT,
          header: {
            Authorization: `Bearer ${access_token}`,
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify({ ids: ['string'] }),
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            Log.info('Follow Artist or User', 'responseCode', data.responseCode);
            if (data.responseCode === 204) {
              Log.info('Follow Artist or User', 'Successfully followed Artist or User');
              resolve(true)
            } else {
              Log.error('Follow Artist or User', `Unexpected response: ${data.responseCode}`);
              reject(`Unexpected response: ${data.responseCode}`);
            }
          }
          else {
            Log.error('Follow Artist or User', err.message)
            reject('Error: ' + err)
          }
        })
    })
  }

  async unfollowArtistsOrUsers(access_token: string, type: string, ids: string): Promise<boolean> {
    return new Promise<boolean>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(api_url + '/me/following' + `?type=${type}&ids=${ids}`,
        {
          method: http.RequestMethod.DELETE,
          header: {
            Authorization: `Bearer ${access_token}`,
            'Content-Type': 'application/json'
          },
          extraData: JSON.stringify({ ids: ['string'] }),
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            Log.info('UnFollow Artist or User', 'responseCode', data.responseCode);
            if (data.responseCode === 204) {
              Log.info('UnFollow Artist or User', 'Successfully unfollowed Artist or User');
              resolve(true)
            } else {
              Log.error('UnFollow Artist or User', `Unexpected response: ${data.responseCode}`);
              reject(`Unexpected response: ${data.responseCode}`);
            }
          }
          else {
            Log.error('UnFollow Artist or User', err.message)
            reject('Error: ' + err)
          }
        })
    })
  }

  async checkIfFollowArtistsOrUsers(access_token: string, type: string, ids: string): Promise<boolean[]> {
    return new Promise<boolean[]>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(api_url + '/me/following/contains' + `?type=${type}&ids=${ids}`,
        {
          method: http.RequestMethod.GET,
          header: {
            Authorization: `Bearer ${access_token}`
          },
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            Log.info('checkIfFollowArtistsOrUsers', 'responseCode', data.responseCode);
            if (data.responseCode === 200) {
              let responseData: boolean[] = JSON.parse(data.result as string)
              resolve(responseData)
            } else {
              Log.error('checkIfFollowArtistsOrUsers', `Unexpected response: ${data.responseCode}`);
              reject(`Unexpected response: ${data.responseCode}`);
            }
          }
          else {
            Log.error('checkIfFollowArtistsOrUsers', err.message)
            reject('Error: ' + err)
          }
        })
    })
  }

  async checkIfFollowPlaylist(access_token: string, playlist_id: string): Promise<boolean[]> {
    return new Promise<boolean[]>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(api_url + `/playlists/${playlist_id}/followers/contains`,
        {
          method: http.RequestMethod.GET,
          header: {
            Authorization: `Bearer ${access_token}`
          },
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            Log.info('checkIfFollowPlaylist', 'responseCode', data.responseCode);
            if (data.responseCode === 200) {
              let responseData: boolean[] = JSON.parse(data.result as string)
              resolve(responseData)
            } else {
              Log.error('checkIfFollowPlaylist', `Unexpected response: ${data.responseCode}`);
              reject(`Unexpected response: ${data.responseCode}`);
            }
          }
          else {
            Log.error('checkIfFollowPlaylist', err.message)
            reject('Error: ' + err)
          }
        })
    })
  }

  // Player
  async getRecentPlayedTracks(access_token: string, limit?: number, after?: number, before?: number): Promise<RecentPlayedTracks> {
    return new Promise<RecentPlayedTracks>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(api_url + `/me/player/recently-played?limit=${limit}`,
        {
          method: http.RequestMethod.GET,
          header: {
            Authorization: `Bearer ${access_token}`
          },
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            Log.info('getRecentPlayedTracks', 'responseCode', data.responseCode);
            if (data.responseCode === 200) {
              let responseData: RecentPlayedTracks = JSON.parse(data.result as string)
              resolve(responseData)
            } else {
              Log.error('getRecentPlayedTracks', `Unexpected response: ${data.responseCode}`);
              reject(`Unexpected response: ${data.responseCode}`);
            }
          }
          else {
            Log.error('getRecentPlayedTracks', err.message)
            reject('Error: ' + err)
          }
        })
    })
  }

  // Artists
  async getArtistTopTracks(access_token: string, id: string, market?: string): Promise<ArtistTopTracks> {
    return new Promise<ArtistTopTracks>((resolve, reject) => {
      let httpRequest = http.createHttp()
      httpRequest.request(api_url + `/artists/${id}/top-tracks?market=${market}`,
        {
          method: http.RequestMethod.GET,
          header: {
            Authorization: `Bearer ${access_token}`
          },
          readTimeout: 30000,
          connectTimeout: 30000,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            Log.info('getArtistTopTracks', 'responseCode', data.responseCode);
            if (data.responseCode === 200) {
              let responseData: ArtistTopTracks = JSON.parse(data.result as string)
              resolve(responseData)
            } else {
              Log.error('getArtistTopTracks', `Unexpected response: ${data.responseCode}`);
              reject(`Unexpected response: ${data.responseCode}`);
            }
          }
          else {
            Log.error('getArtistTopTracks', err.message)
            reject('Error: ' + err)
          }
        })
    })

  }
}

// 调用函数执行请求
export { DataSource, AccessToken }
