import { TopItems } from '../model/UserTopItem'
import { Artist, Cursors } from '../model/Artist';
import { Track } from '../model/Track'
import { CurrentUserProfile } from '../model/UserProfile';
import { PlayHistory, RecentPlayedTracks } from '../model/Play';

// @Entry
@Component
export struct Recommend {
  @Link userTopItems: TopItems
  @Link currentUser: CurrentUserProfile
  @Link recentPlayedTracks: RecentPlayedTracks

  // Unique album played track list
  // @State uniquePlayedTrackHistory: PlayHistory[] = []

  // aboutToAppear() {
  //   let trackMap = new Map<string, PlayHistory>()
  //   this.recentPlayedTracks.items.forEach((item: PlayHistory) => {
  //     let albumName = item.track.album.name;
  //     if (!trackMap.has(albumName)) {
  //       trackMap.set(albumName, item)
  //     }
  //   })
  //   this.uniquePlayedTrackHistory = Array.from(trackMap.values())
  // }

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
        Column() {
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
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .align(Alignment.Top)
    }
    .width('100%')
    .backgroundColor(Color.Black)
  }
}