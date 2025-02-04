import webview from '@ohos.web.webview'

@Entry
@Component
struct Login {
  webController: WebviewController = new webview.WebviewController()
  redirectUrl: string = ''
  @State redirectRes: string = ''

  build() {
    Column() {
      Button(`Load Server Redirect Url`).onClick((event: ClickEvent) => {
        this.webController.loadUrl(this.redirectUrl);
      })
      Web({
        src: $rawfile('jump.html'),
        controller: this.webController
      })
        .domStorageAccess(true)
        .onLoadIntercept((event) => {
          if (event) {
            if (event.data.isRedirect()) {
              console.log('发生3xx系统重定向')
              console.log('系统重定向后url为： ' + event.data.getRequestUrl())
            } else {
              console.log('普通页面跳转')
              console.log('跳转后url为：' + event.data.getRequestUrl())
            }
          }
          return false;
        })
    }
  }
}
