import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';
import { URLSearchParams, SpotifyTokenResponse } from '../model/UserAuthorization';
import hilog from '@ohos.hilog';
import { Log } from '../utils/Log';
import webview from '@ohos.web.webview';
import util from '@ohos.util';

let base64 = new util.Base64Helper();

export class SpotifyAuth {
  private clientId: string = '3b890116acda47138418a110a37334bd';
  private redirectUri: string = 'https://developer.spotify.com/'; // Replace with your redirect URI
  private scope: string = 'user-read-private user-read-email user-top-read';
  private state: string = this.generateRandomState();

  // Function to generate a random state string
  private generateRandomState(): string {
    return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
  }

  // Function to initiate the login process
  public async login(): Promise<string> {
    const authUrl = this.buildAuthUrl()
    Log.info('Auth', 'Redirecting to:', authUrl)
    Log.info('Auth', 'Encode URI Component:', encodeURIComponent(this.scope))
    return authUrl
  }

  // Build the authorization URL
  private buildAuthUrl(): string {
    const queryParams: URLSearchParams = new URLSearchParams('code',
      this.clientId,
      this.scope,
      this.redirectUri,
      this.state)
    // Url worked!
    return `https://accounts.spotify.com/authorize?response_type=code&client_id=${this.clientId}&scope=${encodeURIComponent(this.scope)}&redirect_uri=${this.redirectUri}&state=${this.state}`;
  }

  // Handle the callback from Spotify (exchange the code for a token)
  public async getAccessToken(authCode: string): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      let httpRequest = http.createHttp();

      httpRequest.request(
        'https://accounts.spotify.com/api/token',
        {
          method: http.RequestMethod.POST,
          header: {
            Authorization: `Basic M2I4OTAxMTZhY2RhNDcxMzg0MThhMTEwYTM3MzM0YmQ6ZGIwOGZlMTkzMjEzNDAzYmJhYjVkY2QyNjRhYmYxZjY=`,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          extraData: `grant_type=authorization_code&code=${authCode}&redirect_uri=${encodeURIComponent(this.redirectUri)}`,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            try {
              const response: SpotifyTokenResponse = JSON.parse(data.result as string);
              // Log.info('getAccessToken', 'Access Token:', response);
              resolve(response.access_token);
            } catch (error) {
              Log.error('getAccessToken', 'Failed to parse token response:', error);
              reject(error);
            }
          } else {
            Log.error('getAccessToken', 'Error during token request:', err);
            reject(err);
          }
        }
      );
    });
  }
}
