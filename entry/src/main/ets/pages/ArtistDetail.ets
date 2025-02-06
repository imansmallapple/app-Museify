import { Artist } from '../model/Artist';
import router from '@ohos.router';
import { Log } from '../utils/Log';

@Entry
@Component
struct ArtistDetail {
  // @State artist: Artist = router.getParams() as Artist

  build() {
    Column() {
      Column() {
        Image($r('app.media.app_icon'))
      }
      .width('100%')
      .height('40%')
      .zIndex(1)

      Scroll() {
        Column() {
          List() {
            ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 0], (item: number) => {
              ListItem() {
                Column() {
                  Text(item.toString())
                    .fontColor(Color.White)
                }
                .height('40%')
              }
            })
          }
        }
        .height('100%')
      }
      .width('100%')
      .height('100%')
      .align(Alignment.Top)
      .zIndex(0)
    }
    .width('100%')
    .backgroundColor(Color.Black)
  }
}