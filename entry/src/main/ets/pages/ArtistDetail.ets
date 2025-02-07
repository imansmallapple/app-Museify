import { Artist, Followers, RouterArtist } from '../model/Artist'
import router from '@ohos.router'
import { Log } from '../utils/Log'
import { ExternalUrls } from '../model/Artist'

@Entry
@Component
struct ArtistDetail {
  @State artist: Artist = new Artist(new ExternalUrls(''), new Followers('', 0), [], '', '', [], '', 0, '', '')

  aboutToAppear(): void {
    this.artist = (router.getParams() as RouterArtist).artist
  }

  build() {
    Column() {
      Row({ space: 10 }) {
        Image($r('app.media.icon_back'))
          .width(30)
          .onClick(() => {
            router.back()
          })
        Text(this.artist.name)
          .fontColor(Color.White)
          .fontWeight(700)
          .fontSize(20)
      }
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .height('7%')
      .zIndex(0)
      .margin({ left: 10 })
      .backgroundColor('#ff4e4c4c')

      Scroll() {
        Column() {
          Column() {
            Image(this.artist.images[0].url)
              .objectFit(ImageFit.Cover)
              .zIndex(0)
          }
          .width('100%')
          .height('40%')

          Column() {
          }
          .width('100%')
          .height('100%')
          .backgroundColor(Color.Gray)
        }
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