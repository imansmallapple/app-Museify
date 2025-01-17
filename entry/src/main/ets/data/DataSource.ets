import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';
import { Artist } from '../model/Artist';

const BASE_URL = "https://accounts.spotify.com"

const requestToken = BASE_URL + "/api/token"

const getArtistData = BASE_URL + 'v1/artists/4Z8W4fKeB5YxbusRsdQVPb'

const client_id = "3b890116acda47138418a110a37334bd"
const client_secret = "db08fe193213403bbab5dcd264abf1f6"


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
}


// 调用函数执行请求
export { DataSource, AccessToken }
