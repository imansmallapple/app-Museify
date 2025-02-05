import { AccessToken, DataSource } from '../data/DataSource';
import hilog from '@ohos.hilog';
import { URLSearchParams, UserAuthorizeAccepted, UserAuthorizeDenied } from '../model/UserAuthorization';
import { SpotifyAuth } from '../data/Auth'
import webview from '@ohos.web.webview';
import { Log } from '../utils/Log';
import url from '@ohos.url';
import { ExplicitContent, UserProfile, ExternalUrls, Followers } from '../model/UserProfile';
import router from '@ohos.router'
import { Profile } from './userProfile';
import { TopItems } from '../model/UserTopItem';

@Entry
@Component
struct Index {
  // Login
  @State httpCode: number = 0
  @State access_token: string = ''
  @State token: string = ''
  @State authroizeResult: UserAuthorizeDenied | UserAuthorizeAccepted = new UserAuthorizeAccepted('', '')
  @State loginUrl: string = ''
  private controller: WebviewController = new webview.WebviewController()
  @State authCode: string | null = ''
  private spotifyAuth = new SpotifyAuth()
  private source = new DataSource()
  @State currentUser: UserProfile = new UserProfile('', '', '', new ExplicitContent(false, false),
    new ExternalUrls(''), new Followers('', 0), '', '', [], '', '', '')
  @State isLogged: boolean = false

  // User Top Items
  @State userTopItems: TopItems = new TopItems('',0,'',0,'',0,[])

  aboutToAppear() {
    this.spotifyAuth.login().then(async (authUrl) => {
      Log.info('Auth', 'AuthUrl:', authUrl)
      this.loginUrl = authUrl
    })
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

  getUserProfile(authCode: string) {
    // Get access_token
    this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
      if (AccessToken !== undefined) {
        this.access_token = AccessToken
      }
      Log.info('getAccessToken', this.access_token)
      // Get User Profile
      let res: UserProfile = await this.source.getProfile(this.access_token)
      Log.info('User Profile:', 'res', res)
      this.currentUser = res
      Log.info('User Profile:', 'currentUser', this.currentUser)
      this.isLogged = true
    })
  }

  getUserTopItems(authCode: string) {
    // Get access_token
    this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
      if (AccessToken !== undefined) {
        this.access_token = AccessToken
      }
      // Get User Top Items
      let userTopItems: TopItems = await this.source.getUserTopItems(this.access_token, 'artists')
      Log.info('User Top Items', userTopItems)
      this.userTopItems = userTopItems
      Log.info('User Top Items','state locally', this.userTopItems)
    })
  }

  build() {
    Row() {
      if (!this.isLogged) {
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
                  // 设置拦截代码，拦截重定向后的登陆code和state
                  Log.info('auth', 'redirect', event.data.getRequestUrl())
                  this.authCode = this.extractAuthCode(event.data.getRequestUrl())
                  Log.info('auth', 'code res: ', this.authCode)
                  if (this.authCode !== null && this.authCode.length > 150) {
                    Log.info('User Profile', 'auth Code', this.authCode)

                    // Get User Data
                    this.getUserProfile(this.authCode)
                    this.getUserTopItems(this.authCode)
                  }
                } else {
                  Log.info('auth', 'simple page jumping', event.data.getRequestUrl())
                }
              }
              return false
            })
        }
        .width('100%')
      } else {
        Column() {
          // Text('Logged in!')
          // Profile({currentUser: $currentUser})
        }
        .width('100%')
      }
    }
    .height('100%')
  }
}