import { CurrentUserProfile } from '../model/UserProfile'

@Preview
@Component
export struct Profile {
  // @Link currentUser: CurrentUserProfile

  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.icon_back'))
            .width(16)
            .margin({ left: 10 })
          Blank()
            .layoutWeight(1)
          Image($r('app.media.icon_more'))
            .width(33)
            .height(31)
            .margin({ right: 10 })
        }
        .width('100%')
        .height(50)
        .backgroundColor(Color.Brown)

        //Profile image
        Row() {
          Column({ space: 30 }) {
            Image($r('app.media.startIcon'))
              .width(150)
              .borderRadius(100)

            Button('Edit Profile')
              .type(ButtonType.Normal)
              .borderRadius(15)
              .backgroundColor('#3E3F3F')
          }
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('65%')
        .backgroundColor(Color.White)

        //Bottom bar
        Row({ space: 30 }) {
          Column() {
            Text('23')
              .fontColor(Color.White)
            Text('PLAYLISTS')
              .fontColor('#B3B3B3')
          }

          Column() {
            Text('58')
              .fontColor(Color.White)
            Text('FOLLOWERS')
              .fontColor('#B3B3B3')
          }

          Column() {
            Text('43')
              .fontColor(Color.White)
            Text('FOLLOWING')
              .fontColor('#B3B3B3')
          }
        }
        .justifyContent(FlexAlign.Center)
        .width('100%')
        .height('20%')
        .backgroundColor(Color.Blue)
      }
      .width('100%')
      .height('50%')
      .backgroundColor(Color.Orange)

      Column() {
        Text('PlayList')
      }
      .width('100%')
      .height('50%')
      .backgroundColor(Color.Green)
    }
    .width('100%')
    .height('100%')
  }
}
