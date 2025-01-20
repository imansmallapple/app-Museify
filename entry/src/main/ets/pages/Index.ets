import { AccessToken, DataSource } from '../data/DataSource';
import { Artist } from '../model/Artist';
import hilog from '@ohos.hilog';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State httpCode: number = 0
  @State access_token: string = ''
  aboutToAppear() {

    const source = new DataSource()
    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code
      if (code === 200) {
        //Tested: working
        const res1: AccessToken = await source.requestAccessToken()
        this.access_token = res1.access_token
        hilog.info(0x00, 'Chat Response:', JSON.stringify(res1, null, 2));
        hilog.info(0x00, 'Chat Response:', this.access_token);
        const res2: Artist = await source.getArtistData(this.access_token)
        hilog.info(0x00, 'Artist:', JSON.stringify(res2, null, 2));
      } else {
        hilog.error(0x00, 'Failed to fetch data: HTTP Code', code.toString());
      }
    })
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}