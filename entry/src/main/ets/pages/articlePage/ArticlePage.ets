import router from '@ohos.router'
import EditArticle from './view/EditArticle'
@Entry
@Component
struct ArticlePage {
  @State bookId:number = router.getParams()['bookId']
  title:string = router.getParams()['title']
  content:string = router.getParams()['content']
  coverImg:string = router.getParams()['coverImg']

  aboutToAppear() {
    console.info('info, bookId: '+this.bookId)
    if(this.title) console.log('info, title: '+this.title)
    if(this.content) console.log('info, content: '+this.content)
    if(this.coverImg) console.log('info, coverImg: '+this.coverImg)
    console.log('传值成功')
  }

  build() {
    Scroll() {
      if(this.title && this.content && this.coverImg) {
        EditArticle({
          bookId:this.bookId,
          title:this.title,
          content:this.content,
          coverImg:this.coverImg
        })
      } else {
        EditArticle({
          bookId:this.bookId
        })
      }
    }
  }
}