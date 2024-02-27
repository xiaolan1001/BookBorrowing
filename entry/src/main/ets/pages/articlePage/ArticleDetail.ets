import router from '@ohos.router'
import TitleComponent from '../../common/components/TitleComponent'
import Article from '../../model/Article'
import ArticleRequestUtil from '../../utils/requestUtil/ArticleRequestUtil'
@Entry
@Component
struct ArticleDetail {
  @State article:Article = {
    id:1,
    title:'title',
    content:'content',
    coverImg:'coverImg',
    createUser:1,
    bookId:1,
    createTime:'createTime',
    updateTime:'updateTime'
  }
  articleId:number = router.getParams()['articleId']
  aboutToAppear() {
    try {
      ArticleRequestUtil.getArticleById(this.articleId)
        .then(success => {
          if(success.code === 200) {
            this.article = success.data
          }
        })
    } catch (error) {
      console.error('aboutToAppear, error: '+JSON.stringify(error))
    }
  }

  build() {
    Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.Start}) {
      TitleComponent({
        title:'文章详情',
        isBack:true
      })
        .padding({left:26,right:26})

      Scroll() {
        Column() {
          Image(this.article.coverImg)
            .width('100%')
            .height(300)

          Text(this.article.title)
            .fontSize(20)
            .fontWeight(700)
            .fontColor(Color.Black)
            .margin({top:20})
            .padding({left:26, right:26})

          Text(this.article.content)
            .fontSize(17)
            .fontWeight(400)
            .fontColor(Color.Black)
            .lineHeight('140%')
            .margin({top:9})
            .padding({left:26, right:26})
        }
        .width('100%')
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}