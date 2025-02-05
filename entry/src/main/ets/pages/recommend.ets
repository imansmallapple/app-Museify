import { TopItems } from '../model/UserTopItem'
import { Artist } from '../model/Artist';
import { Track } from '../model/Track'
import { CurrentUserProfile } from '../model/UserProfile';

// @Entry
@Component
export struct Recommend {
  @Link userTopItems: TopItems
  @Link currentUser: CurrentUserProfile
  private topItemList: string[] = ['1', '2', '3', '4', '5', '6', '7', '8']

  aboutToAppear() {

  }

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
          Column() {
            Grid() {
              ForEach(this.userTopItems.items, (item: Artist) => {
                GridItem() {
                  Row({ space: 10 }) {
                    Image(item.images[0].url)
                      .width(40)
                    Text(item.name)
                      .fontSize(20)
                      .fontColor(Color.White)
                  }
                  .width('100%')
                }
              })
            }
            .columnsTemplate('1fr 1fr')
            .rowsTemplate('1fr 1fr 1fr 1fr')
            .width('100%')
            .height('40%')
          }
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