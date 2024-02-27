import router from '@ohos.router'
import Borrow from '../mainPage/view/Borrow'
@Entry
@Component
struct BorrowPage {
  @State message: string = 'Hello World'

  onBackPress() {
    router.pushUrl(
      {
        url:'pages/mainPage/Index'
      },
      router.RouterMode.Single,
      err => {   // 异常响应回调函数
        if(err) {
         console.log(`路由失败, errCode: ${err.code}, errMsg: ${err.message}`)
        }
     }
    )
    // router.RouterMode.Single 返回可以指定页面栈中的页面，似乎也不需要单例模式了。
  }

  build() {
    Column() {
      Borrow()
    }
  }
}