import router from '@ohos.router'
import TitleComponent from '../../../common/components/TitleComponent'
import Article from '../../../model/Article'
import ArticleRequestUtil from '../../../utils/requestUtil/ArticleRequestUtil'
import ArticleItem from '../../articlePage/ArticleItem'
import ArticleItemStyle from '../recommendation/ArticleItemStyle'
@Component
export default struct ArticleView {
  @State articles:Article[] = []
  @State pageNum:number = 1
  @State pageSize:number = 10

  isLoading:boolean = false

  //页面的生命周期钩子，在build函数执行之前先执行
  aboutToAppear() {
    //加载推荐文章数据
    this.loadArticles()
  }

  loadArticles() {
    ArticleRequestUtil.getArticles(this.pageNum,this.pageSize)
      .then(success => {
        if(success.code === 200) {
          console.log('loadArticles, then: '+JSON.stringify(success.data.items))
          this.articles = success.data.items
        }
      })
  }

  // addArticle() {
  //   router.pushUrl({
  //     url:'pages/articlePage/ArticlePage'
  //   })
  // }

  build() {
    Column() {
      //标题
      TitleComponent({
        title:'文章'/*,
        isNew:true,
        add:()=> {
          this.addArticle()
        }*/
      })
      .padding({left:26,right:26})

      Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.Start}) {
        Text('我的文章')
          .fontSize(25)
          .fontWeight(400)

        List({space:24}) {
          ForEach(this.articles, (item:Article) => {
            ListItem() {
              ArticleItem({article:item})
            }
            .onClick(() => {
              router.pushUrl(
                {
                  url:'pages/articlePage/ArticlePage',
                  params:{
                    bookId:item.bookId, //为指定的图书写文章，故需要传参bookId
                    title:item.title,
                    content:item.content,
                    coverImg:item.coverImg
                  }
                }
              )
            })
          })
        }
        .onReachEnd(() => {
          console.log('触底')
        })
        .width('100%')
        .height(600)

        // ForEach(this.articles, (item:Article) => {
        //   ArticleItemStyle({article:item})
        // })
      }
      .width('100%')
      .height('100%')
      .padding({top:23,left:20,right:20})
      .borderRadius(15)
      .backgroundColor(Color.White)

      // List({space:24}) {
      //   ForEach(this.articles, (item:Article) => {
      //     ListItem() {
      //       // ArticleItemStyle({article:item})
      //       ArticleItem({article:item})
      //     }
      //   })
      // }
      // .onReachEnd(() => {
      //   console.log('触底')
      //   //this.pageNum++
      //   if(!this.isLoading) {
      //     this.isLoading = true
      //     this.pageNum++
      //     this.loadArticles()
      //   }
      // })
      // .width('100%')
      // .padding({bottom:58})

    }
    .width('100%')
  }
}