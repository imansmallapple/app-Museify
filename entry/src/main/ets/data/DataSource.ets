import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';
import { Artist } from '../model/Artist';
import { Track } from '../model/Track'
import { CurrentUserProfile, PublicUserProfile } from '../model/UserProfile'
import { UserAuthorizeAccepted, UserAuthorizeDenied } from '../model/UserAuthorization';
import { Log } from '../utils/Log';
import { TopItems } from '../model/UserTopItem';

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

}


// 调用函数执行请求
export { DataSource, AccessToken }
