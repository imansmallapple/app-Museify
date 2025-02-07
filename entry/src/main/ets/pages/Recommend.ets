import { TopItems } from '../model/UserTopItem'
import { Artist, ArtistTopTracks, Cursors } from '../model/Artist';
import { Track } from '../model/Track'
import { CurrentUserProfile } from '../model/UserProfile';
import { PlayHistory, RecentPlayedTracks } from '../model/Play';
import { Log } from '../utils/Log';
import router from '@ohos.router'

// @Entry
@Component
export struct Recommend {
  @Link userTopItems: TopItems
  @Link currentUser: CurrentUserProfile
  @Link recentPlayedTracks: RecentPlayedTracks
  @Link firstTopTracks: ArtistTopTracks
  @Link secondTopTracks: ArtistTopTracks

  build() {
    Column() {
      Row() {
        Image(this.currentUser.images[0].url)
          .width(45)
          .borderRadius(100)
          .onClick(() => {
            // todo: To be implement
          })
      }
      .width('100%')
      .height('10%')
      .backgroundColor(Color.Black)
      .zIndex(1)
      .borderWidth(1)
      .borderColor(Color.White)

      Scroll() {
        Column({ space: 20 }) {
          // User Top Items
          Column() {
            Grid() {
              ForEach(this.userTopItems.items, (item: Artist) => {
                GridItem() {
                  Row({ space: 5 }) {
                    Image(item.images[0].url)
                      .width(60)
                    Text(item.name)
                      .fontSize(20)
                      .fontColor(Color.White)
                  }
                  .width('100%')
                  .backgroundColor('#8d5d5959')
                }
                .margin(10)
              })
            }
            .columnsTemplate('1fr 1fr')
            .rowsTemplate('1fr 1fr 1fr 1fr')
            .columnsGap(10)
            .width('100%')
            .height('40%')
          }
          .width('100%')

          Column() {
            // User recent played tracks
            Column() {
              Text('Recent Played')
                .fontColor(Color.White)
                .fontSize(30)
                .fontWeight(FontWeight.Bold)
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .margin({ bottom: 10 })

            List() {
              ForEach(this.recentPlayedTracks.items, (item: PlayHistory) => {
                ListItem() {
                  Column({ space: 5 }) {
                    Image(item.track.album.images[0].url)
                      .width(150)
                    Row() {
                      Text(item.track.name)
                        .fontColor(Color.White)
                        .fontSize(15)
                        .maxLines(2)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                    .width('100%')
                    .justifyContent(FlexAlign.Start)
                  }
                  .alignItems(HorizontalAlign.Start)
                  .width(190)
                }
              })
            }
            .listDirection(Axis.Horizontal)
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')

          // 1st artist fan special
          if (this.userTopItems.items[0] !== undefined && this.userTopItems.items[0] !== null) {
            Column({ space: 10 }) {
              // User favorite artist recommendation
              Row({ space: 10 }) {
                Column() {
                  Image(`${(this.userTopItems.items[0] as Artist).images[0].url}`)
                    .borderRadius(100)
                }
                .width(70)

                Column() {
                  Text('Fans Special')
                    .fontColor(Color.White)
                    .fontSize(20)
                    .fontWeight(FontWeight.Medium)
                  Text(`${this.userTopItems.items[0].name}`)
                    .fontColor(Color.White)
                    .fontSize(30)
                    .fontWeight(FontWeight.Bold)
                }
                .width('100%')
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Center)
                .margin({ bottom: 10 })
              }
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ArtistDetail',
                  params: {
                    artist: this.userTopItems.items[0]
                  }
                })
              })

              List() {
                ForEach(this.firstTopTracks.tracks, (item: Track) => {
                  ListItem() {
                    Column({ space: 5 }) {
                      Image(item.album.images[0].url)
                        .width(150)
                      Row() {
                        Text(item.name)
                          .fontColor(Color.White)
                          .fontSize(15)
                          .maxLines(2)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                      }
                      .width('100%')
                      .justifyContent(FlexAlign.Start)
                    }
                    .alignItems(HorizontalAlign.Start)
                    .width(190)
                  }
                })
              }
              .listDirection(Axis.Horizontal)
            }
            .alignItems(HorizontalAlign.Start)
            .width('100%')
          }

          // 2nd artist fan special
          if (this.userTopItems.items[1] !== undefined && this.userTopItems.items[1] !== null) {
            Column({ space: 10 }) {
              // User favorite artist recommendation
              Row({ space: 10 }) {
                Column() {
                  Image(`${(this.userTopItems.items[1] as Artist).images[0].url}`)
                    .borderRadius(100)
                }
                .width(70)

                Column() {
                  Text('Fans Special')
                    .fontColor(Color.White)
                    .fontSize(20)
                    .fontWeight(FontWeight.Medium)
                  Text(`${this.userTopItems.items[1].name}`)
                    .fontColor(Color.White)
                    .fontSize(30)
                    .fontWeight(FontWeight.Bold)
                }
                .width('100%')
                .alignItems(HorizontalAlign.Start)
                .justifyContent(FlexAlign.Center)
                .margin({ bottom: 10 })
              }
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/ArtistDetail',
                  params: {
                    artist: this.userTopItems.items[1]
                  }
                })
              })

              List() {
                ForEach(this.secondTopTracks.tracks, (item: Track) => {
                  ListItem() {
                    Column({ space: 5 }) {
                      Image(item.album.images[0].url)
                        .width(150)
                      Row() {
                        Text(item.name)
                          .fontColor(Color.White)
                          .fontSize(15)
                          .maxLines(2)
                          .textOverflow({ overflow: TextOverflow.Ellipsis })
                      }
                      .width('100%')
                      .justifyContent(FlexAlign.Start)
                    }
                    .alignItems(HorizontalAlign.Start)
                    .width(190)
                  }
                })
              }
              .listDirection(Axis.Horizontal)
            }
            .alignItems(HorizontalAlign.Start)
            .width('100%')
          }
        }
        .width('100%')
      }
      .width('100%')
      .height('88%')
      .align(Alignment.Top)
    }
    .width('100%')
    .backgroundColor(Color.Black)
  }
}