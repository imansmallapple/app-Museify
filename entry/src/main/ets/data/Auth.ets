import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';
import { URLSearchParams, SpotifyTokenResponse } from '../model/UserAuthorization';
import hilog from '@ohos.hilog';
import { Log } from '../utils/Log';
<<<<<<< HEAD
import webview from '@ohos.web.webview';
import util from '@ohos.util';

let base64 = new util.Base64Helper();
=======
>>>>>>> 648390f708f80df6b776fd1dae01d7b17a035f84

export class SpotifyAuth {
  private clientId: string = '3b890116acda47138418a110a37334bd';
  private redirectUri: string = 'https://developer.spotify.com/'; // Replace with your redirect URI
  private scope: string = 'user-read-private user-read-email';
  private state: string = this.generateRandomState();

  // Function to generate a random state string
  private generateRandomState(): string {
    return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
  }

  // Function to initiate the login process
<<<<<<< HEAD
  public async login(): Promise<string> {
    const authUrl = this.buildAuthUrl()
    // Log.info('Auth', 'Redirecting to:', authUrl)
    this.handleCallback()
    return authUrl
=======
  public async login(): Promise<void> {
    const authUrl = this.buildAuthUrl();
    Log.info('Auth', 'Redirecting to:', authUrl);

    // Simulate opening the URL in a browser
    // You would typically use a web view or redirect mechanism in an actual app
    // Here we only log it for demonstration
>>>>>>> 648390f708f80df6b776fd1dae01d7b17a035f84
  }

  // Build the authorization URL
  private buildAuthUrl(): string {
    const queryParams: URLSearchParams = new URLSearchParams('code',
      this.clientId,
      this.scope,
      this.redirectUri,
      this.state)

    // Url worked!
    return `https://accounts.spotify.com/authorize?response_type=code&client_id=${this.clientId}&scope=user-read-private%20user-read-email&redirect_uri=${this.redirectUri}&state=${this.state}`;
  }

  // Handle the callback from Spotify (exchange the code for a token)
  public async handleCallback(): Promise<void> {
    let authCode: string = 'AQBek5pm-0RmTrPluYzO9SxIINWX9qa9icHwpq4cHmcrl3yTYNL8JR3uH_T9CDNj3s0I6IR2RU5xLZQF4hw44YPfSbOpt5Z4A64nYactzO6vbbGWV6vGsfiz-YTkFHyL8_g9Lpq_s6gz-B5KnqfRCnTsQzBB5ZiEf7LGtmxE0IzpVyiLE2IKBtv5svL8-2dwjNHFTClty4ZB4RjGxsFXUadBt-WFJQ'
    return new Promise<void>((resolve, reject) => {
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
<<<<<<< HEAD
              Log.info('handle callback', 'Access Token:', response);
=======
              console.info('Access Token:', response.access_token);
>>>>>>> 648390f708f80df6b776fd1dae01d7b17a035f84
              resolve();
            } catch (error) {
              Log.error('handle callback', 'Failed to parse token response:', error);
              reject(error);
            }
          } else {
            Log.error('handle callback', 'Error during token request:', err);
            reject(err);
          }
        }
      );
    });
  }
}
