import router from '@ohos.router'
import TitleComponent from '../../../common/components/TitleComponent'
import Article from '../../../model/Article'
import ArticleRequestUtil from '../../../utils/requestUtil/ArticleRequestUtil'
import ArticleItem from '../../articlePage/ArticleItem'
import ArticleItemStyle from '../recommendation/ArticleItemStyle'
@Component
export default struct Home {
  @State searchText:string = '铃芽之旅'
  @State articles:Article[] = []
  isLoading:boolean = false
  isMore:boolean = true
  pageNum:number = 1
  pageSize:number = 2

  //页面的生命周期钩子，在build函数执行之前先执行
  aboutToAppear() {
    //加载推荐文章数据
    this.loadArticles()
  }

  /**
   * 查找图书
   */
  doSearch() {
    // 进入搜索页面
    router.pushUrl({
      url:'pages/searchPage/SearchPage',
      params:{
        content:this.searchText
      }
    })
  }

  loadArticles() {
    ArticleRequestUtil.getRecommendation(this.pageNum,this.pageSize)
      .then(success => {
        if(success.code == 200) {
          console.log('loadArticles, success: '+JSON.stringify(success.data.items))
          this.articles = this.articles.concat(success.data.items)
          this.isLoading = false
          if(!success.data.items || success.data.items.length === 0) {
            this.isMore = false
          }
        }
      })
  }

  build() {
    Column() {
      //标题
      TitleComponent({
        title:'首页'
      })
      Flex({justifyContent:FlexAlign.SpaceBetween, alignItems:ItemAlign.Center}) {
        Image($r('app.media.ic_search'))
          .width(20)
          .height(20)
          .interpolation(ImageInterpolation.High)
          .onClick(() => {
            this.doSearch()
          })

        TextInput({
          placeholder:'Search by title, content...'
        })
          .width('100%')
          .enterKeyType(EnterKeyType.Search)
          .placeholderFont({size:11,weight:400})
          .placeholderColor('rgba(0,0,0,0.4)')
          .margin({left:10})
          .backgroundColor(Color.White)
          .borderRadius(10)
          .onChange((val) => {
            this.searchText = val
          })
          .onSubmit(() => {
            this.doSearch()
          })
      }
      .width('100%')
      .height(41)
      .margin({top:31,bottom:36})
      .padding({left:19,right:19})
      .border({width:1,radius:10,color:'rgba(0,0,0,0.25)'})
      .backgroundColor(Color.White)
      .shadow({offsetX:4,offsetY:4,radius:10,color:'rgba(0,0,0,0.25)'})

      Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.Start}) {
        Text('最新推荐')
          .fontSize(25)
          .fontWeight(400)

        List({space:24}) {
          ForEach(this.articles, (item:Article) => {
            ListItem() {
              ArticleItem({article:item})
            }
            .onClick(() => {
              router.pushUrl({
                url:'pages/articlePage/ArticleDetail',
                params:{
                  articleId:item.id
                }
              })
            })
          })
        }
        .onReachEnd(() => {
          console.log('触底')
          if(!this.isLoading && this.isMore) {
            this.isLoading = true
            this.pageNum++
            console.log('加载'+this.pageNum)
            this.loadArticles()
          }
        })
        .width('100%')
        .height(400)

        // ForEach(this.articles, (item:Article) => {
        //   ArticleItemStyle({article:item})
        // })
      }
      .width('100%')
      .height('100%')
      .padding({top:23,left:20,right:20/*,bottom:68*/})
      .borderRadius(15)
      .backgroundColor(Color.White)

      //标题组件不跟随内容滑动，与底部导航栏有冲突，暂不启用
      // Scroll() {
      //   Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.Start}) {
      //     Text('最新推荐')
      //       .fontSize(25)
      //       .fontWeight(400)
      //
      //     Flex({justifyContent:FlexAlign.SpaceBetween}) {
      //       ArticleItemStyle({articleItem:new ArticleItem('https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/60d1e846-f5bb-4240-bf91-a98db883e720.jpg','铃芽之旅')})
      //       ArticleItemStyle({articleItem:new ArticleItem('https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/60d1e846-f5bb-4240-bf91-a98db883e720.jpg','铃芽之旅')})
      //     }
      //     Flex({justifyContent:FlexAlign.SpaceBetween}) {
      //       ArticleItemStyle({articleItem:new ArticleItem('https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/60d1e846-f5bb-4240-bf91-a98db883e720.jpg','铃芽之旅')})
      //       ArticleItemStyle({articleItem:new ArticleItem('https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/60d1e846-f5bb-4240-bf91-a98db883e720.jpg','铃芽之旅')})
      //     }
      //     Flex({justifyContent:FlexAlign.SpaceBetween}) {
      //       ArticleItemStyle({articleItem:new ArticleItem('https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/60d1e846-f5bb-4240-bf91-a98db883e720.jpg','铃芽之旅')})
      //       ArticleItemStyle({articleItem:new ArticleItem('https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/60d1e846-f5bb-4240-bf91-a98db883e720.jpg','铃芽之旅')})
      //     }
      //     Flex({justifyContent:FlexAlign.SpaceBetween}) {
      //       ArticleItemStyle({articleItem:new ArticleItem('https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/60d1e846-f5bb-4240-bf91-a98db883e720.jpg','铃芽之旅')})
      //       ArticleItemStyle({articleItem:new ArticleItem('https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/60d1e846-f5bb-4240-bf91-a98db883e720.jpg','铃芽之旅')})
      //     }
      //   }
      //   .width('100%')
      //   // .margin({top:36})
      //   .padding({top:23,left:20,right:20})
      //   .borderRadius(15)
      //   .backgroundColor(Color.White)
      // }



      //废弃布局，与上面样式类似
      // Column() {
      //   Flex({justifyContent:FlexAlign.Start,alignItems:ItemAlign.Center}) {
      //     Text('最新推荐')
      //       .fontSize(25)
      //       .fontWeight(400)
      //   }
      //
      //
      // }
      // .width('100%')
      // .margin({top:36})
      // .padding({top:23,left:20,right:20})
      // .borderRadius(15)
      // .backgroundColor(Color.White)
    }
    .width('100%')
    .padding({left:26, right:26})
  }
}