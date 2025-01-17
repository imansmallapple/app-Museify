import { AccessToken, DataSource } from '../data/DataSource';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State httpCode: number = 0

  aboutToAppear() {

    const source = new DataSource()
    source.fetchHttpCode().then(async (code) => {
      this.httpCode = code
      if (code === 200) {
        const res: AccessToken = await source.requestAccessToken()
        console.log('Chat Response:', JSON.stringify(res, null, 2));
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