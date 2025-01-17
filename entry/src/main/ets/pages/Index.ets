import { AccessToken, DataSource } from '../data/DataSource';
import { Artist } from '../model/Artist';

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
        console.log('Chat Response:', JSON.stringify(res1, null, 2));
        console.log('Chat Response:', this.access_token);
        const res2: Artist = await source.getArtistData(this.access_token)
        console.log('Artist:', JSON.stringify(res2, null, 2));
      } else {
        console.error('Failed to fetch data: HTTP Code', code);
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