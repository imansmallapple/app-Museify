import { AccessToken, DataSource } from '../data/DataSource';
import hilog from '@ohos.hilog';
import { URLSearchParams, UserAuthorizeAccepted, UserAuthorizeDenied } from '../model/UserAuthorization';
import { SpotifyAuth } from '../data/Auth'
import webview from '@ohos.web.webview';
import { Log } from '../utils/Log';
import url from '@ohos.url';
import { UserProfile } from '../model/UserProfile';

@Entry
@Component
struct Index {
  @State httpCode: number = 0
  @State access_token: string = ''
  @State token: string = ''
  @State authroizeResult: UserAuthorizeDenied | UserAuthorizeAccepted = new UserAuthorizeAccepted('', '')
  @State loginUrl: string = ''
  private controller: WebviewController = new webview.WebviewController()
  @State authCode: string | null = ''
  private spotifyAuth = new SpotifyAuth()
  private source = new DataSource()

  aboutToAppear() {
    this.spotifyAuth.login().then(async (authUrl) => {
      Log.info('Auth', 'AuthUrl:', authUrl)
      this.loginUrl = authUrl
    })
    //
    //
    // const source = new DataSource()
    // source.fetchHttpCode().then(async (code) => {
    //   this.httpCode = code
    //   if (code === 200) {
    //     //Tested: working
    //     const res1: AccessToken = await source.requestAccessToken()
    //     this.access_token = res1.access_token
    //     hilog.info(0x00, 'Chat Response:', JSON.stringify(res1, null, 2));
    //     hilog.info(0x00, 'Chat Response:', this.access_token);
    //     // const res2: Artist = await source.getArtistData(this.access_token)
    //     // hilog.info(0x00, 'Artist:', JSON.stringify(res2, null, 2));
    //     // const res3: Track = await source.getTrack(this.access_token)
    //     // hilog.info(0x00, 'TrackInfo:', JSON.stringify(res3, null, 2));
    //     this.authroizeResult = await source.login()
    //     hilog.info(0x00, 'TokenReturn:', JSON.stringify(this.authroizeResult, null, 2));
    //
    //     // const res4: UserProfile = await source.getProfile(this.access_token)
    //     // hilog.info(0x00, 'UserProfile:', JSON.stringify(res4, null, 2));
    //   } else {
    //     hilog.error(0x00, 'Failed to fetch data: HTTP Code', code.toString());
    //   }
    // })
  }

  extractAuthCode(url: string): string | null {
    try {
      const queryStart = url.indexOf('?')
      if (queryStart === -1) {
        Log.error('auth', 'No query string found in URL')
        return null;
      }

      const queryString = url.substring(queryStart + 1)
      const paramsArray = queryString.split('&')

      for (let i = 0; i < paramsArray.length; i++) {
        const param = paramsArray[i]
        const keyValuePair = param.split('=')

        if (keyValuePair.length === 2 && keyValuePair[0] === 'code') {
          const decodedCode = decodeURIComponent(keyValuePair[1])
          // Log.info('auth', 'Extracted Authorization Code:', decodedCode)
          return decodedCode
        }
      }

      Log.error('auth', 'Authorization code not found in URL')
      return null
    } catch (error) {
      Log.error('auth', 'Error extracting auth code:', error)
      return null
    }
  }

  getAccessToken(authCode: string) {

    // Get access_token
    this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
      if (AccessToken !== undefined) {
        this.access_token = AccessToken
      }
      // Log.info('getAccessToken', this.access_token)

      // Get User Profile
      let res: UserProfile = await this.source.getProfile(this.access_token)
      Log.info('User Profile:', JSON.stringify(res, null, 2))


    })
  }

  build() {
    Row() {
      Column() {
        Web({ src: this.loginUrl, controller: this.controller })
          .width('100%')
          .height('110%')
          .padding({ bottom: 56 })
          .javaScriptAccess(true)
          .fileAccess(true)
          .domStorageAccess(true)
          .zoomAccess(true)
          .onLoadIntercept((event) => {
            if (event) {
              if (event.data.isRedirect()) {
                // todo: 设置拦截代码，拦截重定向后的登陆code和state
                Log.info('auth', 'redirect', event.data.getRequestUrl())
                this.authCode = this.extractAuthCode(event.data.getRequestUrl())
                Log.info('auth', 'code res: ', this.authCode)
                if (this.authCode !== null && this.authCode.length > 150) {
                  Log.info('User Profile', 'auth Code', this.authCode)
                  this.getAccessToken(this.authCode)
                  //already get access token
                }
              } else {
                Log.info('auth', 'simple page jumping', event.data.getRequestUrl())
              }
            }
            return false
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}