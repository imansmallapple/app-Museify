import { AccessToken, DataSource } from '../data/DataSource';
import hilog from '@ohos.hilog';
import { URLSearchParams, UserAuthorizeAccepted, UserAuthorizeDenied } from '../model/UserAuthorization';
import { SpotifyAuth } from '../data/Auth'
import webview from '@ohos.web.webview';
import { Log } from '../utils/Log';
import url from '@ohos.url';
import { ExplicitContent, CurrentUserProfile, ExternalUrls, Followers, PublicUserProfile } from '../model/UserProfile';
import router from '@ohos.router'
import { Profile } from './UserProfile';
import { TopItems } from '../model/UserTopItem';
import { ArtistTopTracks, Cursors, FollowedArtists } from '../model/Artist';
import { Recommend } from './Recommend';
import { RecentPlayedTracks } from '../model/Play';
import { Artist, Track } from '../model/Track';

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
  @State currentUser: CurrentUserProfile = new CurrentUserProfile('', '', '', new ExplicitContent(false, false),
    new ExternalUrls(''), new Followers('', 0), '', '', [], '', '', '')
  @State isLogged: boolean = false
  // User Top Items
  @State userTopItems: TopItems = new TopItems('', 0, '', 0, '', 0, [])
  // Public User Profile
  @State publicUserProfile: PublicUserProfile = new PublicUserProfile('', new ExternalUrls(''), new Followers('', 0),
    '', '', [], '')
  // Play
  @State recentPlayedTracks: RecentPlayedTracks = new RecentPlayedTracks('', 0, '', new Cursors('', ''), 0, [])
  // Artists
  @State firstTopTracks: ArtistTopTracks = new ArtistTopTracks([])
  @State secondTopTracks: ArtistTopTracks = new ArtistTopTracks([])
  private countryCode: string = 'PL'

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

  // User

  getUserProfile(authCode: string) {
    // Get access_token
    this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
      if (AccessToken !== undefined) {
        this.access_token = AccessToken
      }
      Log.info('getAccessToken', this.access_token)
      // Get User Profile
      let res: CurrentUserProfile = await this.source.getCurrentUserProfile(this.access_token)
      // Log.info('User Profile:', 'res', res)
      this.currentUser = res
      // Log.info('User Profile:', 'currentUser', this.currentUser)
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
      // Log.info('User Top Items', userTopItems)
      this.userTopItems = userTopItems


      // Artists top tracks
      if (this.userTopItems.items[0] !== undefined) {
        let result1: ArtistTopTracks = await this.source.getArtistTopTracks(this.access_token, this.userTopItems.items[0].id, this.countryCode)
        let result2: ArtistTopTracks = await this.source.getArtistTopTracks(this.access_token, this.userTopItems.items[1].id, this.countryCode)
        this.firstTopTracks = result1
        this.secondTopTracks = result2
      }
    })
  }

  getPublicUserProfile(authCode: string, user_id: string) {
    // Get access_token
    this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
      if (AccessToken !== undefined) {
        this.access_token = AccessToken
      }
      // Get Public User Profile
      let dstUser: PublicUserProfile = await this.source.getPublicUserProfile(this.access_token, user_id)
      // Log.info('User Public profile', 'test temp', dstUser)
      this.publicUserProfile = dstUser
      // Log.info('User Public profile', 'test local', this.publicUserProfile)
    })
  }

  followList(authCode: string, playlist_id: string) {
    // Get access_token
    this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
      if (AccessToken !== undefined) {
        this.access_token = AccessToken
      }
      // Follow playlist
      let addResult: boolean = await this.source.followPlaylist(this.access_token, playlist_id)
      Log.info('Follow Playlist', 'test temp', addResult)
    })
  }

  unfollowList(authCode: string, playlist_id: string) {
    // Get access_token
    this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
      if (AccessToken !== undefined) {
        this.access_token = AccessToken
      }
      // Unfollow playlist
      let removeResult: boolean = await this.source.unfollowPlaylist(this.access_token, playlist_id)
      Log.info('Unfollow Playlist', 'test temp', removeResult)
    })
  }

  getFollowedArtists(authCode: string) {
    // Get access_token
    this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
      if (AccessToken !== undefined) {
        this.access_token = AccessToken
      }
      // Get Public User Profile
      let followedArtists: FollowedArtists = await this.source.getFollowedArtists(this.access_token)
      Log.info('User Followed Artists', 'test temp', followedArtists)
    })
  }

  followArtistsOrUsers(authCode: string, type: string, ids: string) {
    // Get access_token
    this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
      if (AccessToken !== undefined) {
        this.access_token = AccessToken
      }
      // Follow Artists or Users
      let followResult: boolean = await this.source.followArtistsOrUsers(this.access_token, type, ids)
      Log.info('User Followed Artists or Users', 'test temp', followResult)
    })
  }

  unfollowArtistsOrUsers(authCode: string, type: string, ids: string) {
    // Get access_token
    this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
      if (AccessToken !== undefined) {
        this.access_token = AccessToken
      }
      // Follow Artists or Users
      let unfollowResult: boolean = await this.source.unfollowArtistsOrUsers(this.access_token, type, ids)
      Log.info('User Unfollowed Artists or Users', 'test temp', unfollowResult)
    })
  }

  checkIfFollowArtistsOrUsers(authCode: string, type: string, ids: string) {
    // Get access_token
    this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
      if (AccessToken !== undefined) {
        this.access_token = AccessToken
      }
      // Check Follow Artists or Users
      let checkResult: boolean[] = await this.source.checkIfFollowArtistsOrUsers(this.access_token, type, ids)
      Log.info('checkIfFollowArtistsOrUsers', 'test temp', checkResult)
    })
  }

  checkIfFollowPlaylist(authCode: string, playlist_id: string) {
    // Get access_token
    this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
      if (AccessToken !== undefined) {
        this.access_token = AccessToken
      }
      let checkResult: boolean[] = await this.source.checkIfFollowPlaylist(this.access_token, playlist_id)
      Log.info('checkIfFollowPlaylist', 'test temp', checkResult)
    })
  }

  // Play
  getRecentPlayedTracks(authCode: string, limit?: number, after?: number, before?: number) {
    // Get access_token
    this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
      if (AccessToken !== undefined) {
        this.access_token = AccessToken
      }
      let result: RecentPlayedTracks = await this.source.getRecentPlayedTracks(this.access_token, limit)
      this.recentPlayedTracks = result
    })
  }

  // Artists
  // getArtistTopTracks(authCode: string, id: string, market?: string) {
  //   // Get access_token
  //   this.spotifyAuth.getAccessToken(authCode).then(async (AccessToken) => {
  //     if (AccessToken !== undefined) {
  //       this.access_token = AccessToken
  //     }
  //     // Check Follow Artists or Users
  //     let result: ArtistTopTracks = await this.source.getArtistTopTracks(this.access_token, id, market)
  //     Log.info('getArtistTopTracks', 'test temp', result)
  //     // this.recentPlayedTracks = result
  //     this.firstTopTracks = result
  //     // Log.info('getArtistTopTracks', 'test local',  this.firstTopTracks)
  //   })
  // }

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

                    // Tested: working
                    // // Test Get Public User Profile
                    // this.getPublicUserProfile(this.authCode, 'taylorswift')
                    //
                    // // Test add follow list
                    // this.unfollowList(this.authCode, '3cEYpjA9oz9GiPac4AsH4n')

                    // this.getFollowedArtists(this.authCode)

                    // Tested (un)follow 3 artists at one time
                    // this.followArtistsOrUsers(this.authCode, 'artist', '2CIMQHirSU0MQqyYHq0eOx,57dN52uHvrHOxijzpIgu3E,1vCWHaC5f2uS3yhpwWbIA6')
                    // this.unfollowArtistsOrUsers(this.authCode, 'artist', '2CIMQHirSU0MQqyYHq0eOx,57dN52uHvrHOxijzpIgu3E,1vCWHaC5f2uS3yhpwWbIA6')

                    // Test checking if user follow artists or users
                    // this.checkIfFollowArtistsOrUsers(this.authCode, 'artist', '2CIMQHirSU0MQqyYHq0eOx,57dN52uHvrHOxijzpIgu3E,1vCWHaC5f2uS3yhpwWbIA6')

                    // this.checkIfFollowPlaylist(this.authCode, '3cEYpjA9oz9GiPac4AsH4n')

                    // Player
                    this.getRecentPlayedTracks(this.authCode, 10)

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
          Recommend({
            userTopItems: $userTopItems,
            currentUser: $currentUser,
            recentPlayedTracks: $recentPlayedTracks,
            firstTopTracks: $firstTopTracks,
            secondTopTracks: $secondTopTracks,
          })
        }
        .width('100%')
      }
    }
    .height('100%')
  }
}