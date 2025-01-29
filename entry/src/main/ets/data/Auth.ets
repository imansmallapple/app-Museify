import http from '@ohos.net.http';
import { BusinessError } from '@ohos.base';
import { URLSearchParams, SpotifyTokenResponse } from '../model/UserAuthorization';
import hilog from '@ohos.hilog';

export class SpotifyAuth {
  private clientId: string = 'YOUR_CLIENT_ID';
  private redirectUri: string = 'http://localhost:8888/callback'; // Replace with your redirect URI
  private scope: string = 'user-read-private user-read-email';
  private state: string = this.generateRandomState();

  // Function to generate a random state string
  private generateRandomState(): string {
    return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
  }

  // Function to initiate the login process
  public async login(): Promise<void> {
    const authUrl = this.buildAuthUrl();
    hilog.info(0x00,'Redirecting to:', authUrl);

    // Simulate opening the URL in a browser
    // You would typically use a web view or redirect mechanism in an actual app
    // Here we only log it for demonstration
  }

  // Build the authorization URL
  private buildAuthUrl(): string {
    const queryParams: URLSearchParams = new URLSearchParams('code',
      this.clientId,
      this.scope,
      this.redirectUri,
      this.state)

    return `https://accounts.spotify.com/authorize?${queryParams.toString()}`;
  }

  // Handle the callback from Spotify (exchange the code for a token)
  public async handleCallback(authCode: string): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      let httpRequest = http.createHttp();

      httpRequest.request(
        'https://accounts.spotify.com/api/token',
        {
          method: http.RequestMethod.POST,
          header: {
            // Authorization: `Basic ${btoa('YOUR_CLIENT_ID:YOUR_CLIENT_SECRET')}`,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          extraData: `grant_type=authorization_code&code=${authCode}&redirect_uri=${encodeURIComponent(this.redirectUri)}`,
        },
        (err: BusinessError, data: http.HttpResponse) => {
          if (!err) {
            try {
              const response:SpotifyTokenResponse = JSON.parse(data.result as string);
              console.info('Access Token:', response.access_token);
              resolve();
            } catch (error) {
              console.error('Failed to parse token response:', error);
              reject(error);
            }
          } else {
            console.error('Error during token request:', err);
            reject(err);
          }
        }
      );
    });
  }
}
