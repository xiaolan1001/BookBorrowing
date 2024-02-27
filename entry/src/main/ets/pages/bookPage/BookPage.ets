import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import TitleComponent from '../../common/components/TitleComponent'
import { Book } from '../../model/Book'
import BookRequestUtil from '../../utils/requestUtil/BookRequestUtil'
import CategoryRequestUtil from '../../utils/requestUtil/CategoryRequestUtil'
import RecordRequestUtil from '../../utils/requestUtil/RecordRequestUtil'
@Entry
@Component
struct BookPage {
  @State bookId:number = router.getParams()['bookId']
  @State category:string = ''

  @State book:Book = {
    title:'title',
    author:'author',
    isbn:'isbn',
    bookContent:'content',
    bookCoverImg:'imgUrl',
    publisher:'publisher',
    availableCopies:0,
    totalCopies:0
  }

  async aboutToAppear() {
    // TODO 加载图书信息
    console.info('bookId: '+this.bookId)
    try {
      await BookRequestUtil.searchBookById(this.bookId)
        .then(success => {
          if(success.code === 200) {
            console.log('aboutToAppear, 查找id成功')
            this.book = success.data
          }
        })
    } catch (error) {
      console.error('aboutToAppear, 查找id失败')
    }
    if(this.book.categoryId) {
      try {
        await CategoryRequestUtil.getCategory(this.book.categoryId)
          .then(success => {
            if(success.code === 200) {
              console.log('aboutToAppear, 获取category成功')
              this.category = success.data.categoryName
            }
          })
      } catch (error) {
        console.error('aboutToAppear, error')
      }
    }
  }

  doBorrow() {
    try {
      RecordRequestUtil.postRecord(this.bookId)
        .then(success => {
          if(success.code === 200) {
            promptAction.showToast({duration:2000,message:'借阅成功'})
            setTimeout(() => {
              router.pushUrl({
                url:'pages/borrowPage/BorrowPage'
              })
            },2000)
          } else {
            promptAction.showToast({duration:2000,message:success.message})
          }
        })
    } catch (error) {
      promptAction.showToast({duration:2000,message:error})
    }
  }

  doShare() {
    router.pushUrl({
      url:'pages/articlePage/ArticlePage',
      params:{
        bookId:this.book.id
      }
    })
  }

  build() {
    // 在使用Scroll组件时，明明设置了滚动方向，内容也超过了视口范围，但是就是不能滚动，这是因为Scroll容器的子组件设置了width或height，
    // Row不要设置width，Column不要设置height。
    Column() { //最多包含一个子组件
      TitleComponent({
        title:'详情',
        isBack:true
      })
        .padding({left:26,right:26})
      Scroll() {
        Column() {
          Image(this.book.bookCoverImg)
            .width(183)
            .height(271)
            .borderRadius(7)
          Text(this.book.title)
            .fontSize(32)
            .fontWeight(400)
            .fontColor(Color.Black)
            .textAlign(TextAlign.Center)
            .margin({top:20})
          Text(this.book.author)
            .fontSize(20)
            .fontWeight(400)
            .fontColor('rgba(0,0,0,0.4)')
            .textAlign(TextAlign.Center)
            .margin({top:15})

          Flex({justifyContent:FlexAlign.SpaceAround}) {
            Image($r('app.media.ic_nav_borrow'))
              .width(28)
              .height(28)
              .padding(2)
              .borderRadius(28)
              .shadow({offsetY:1,offsetX:1,radius:4,color:'rgba(0,0,0,0.4)'})
              .interpolation(ImageInterpolation.High)
              .onClick(() => {
                this.doBorrow()
              })

            Image($r('app.media.ic_book_share'))
              .width(28)
              .height(28)
              .padding(2)
              .borderRadius(28)
              .shadow({offsetY:1,offsetX:1,radius:4,color:'rgba(0,0,0,0.4)'})
              .interpolation(ImageInterpolation.High)
              .onClick(() => {
                this.doShare()
              })
          }
          .margin({top:8})

          Column() {
            Flex({alignItems:ItemAlign.Center}){
              Text('分类')
                .fontSize(14)
                .fontColor('#121212')
                .lineHeight('140%')
              Text(this.category)
                .fontSize(14)
                .fontColor('#121212')
                .lineHeight('140%')
                .margin({left:5})
            }
            .width('100%')

            Flex({alignItems:ItemAlign.Center}){
              Text('ISBN')
                .fontSize(14)
                .fontColor('#121212')
                .lineHeight('140%')
              Text(this.book.isbn)
                .fontSize(14)
                .fontColor('#121212')
                .lineHeight('140%')
                .margin({left:5})
            }
            .width('100%')
            .margin({top:8})

            Flex({alignItems:ItemAlign.Center}){
              Text('出版社')
                .fontSize(14)
                .fontColor('#121212')
                .lineHeight('140%')
              Text(this.book.publisher)
                .fontSize(14)
                .fontColor('#121212')
                .lineHeight('140%')
                .margin({left:5})
            }
            .width('100%')
            .margin({top:8})

            Flex({alignItems:ItemAlign.Center}){
              Text('可借阅本数')
                .fontSize(14)
                .fontColor('#121212')
                .lineHeight('140%')
              Text(this.book.availableCopies.toString())
                .fontSize(14)
                .fontColor('#121212')
                .lineHeight('140%')
                .margin({left:5})
            }
            .width('100%')
            .margin({top:8})

            Flex({alignItems:ItemAlign.Center}){
              Text('总本数')
                .fontSize(14)
                .fontColor('#121212')
                .lineHeight('140%')
              Text(this.book.totalCopies.toString())
                .fontSize(14)
                .fontColor('#121212')
                .lineHeight('140%')
                .margin({left:5})
            }
            .width('100%')
            .margin({top:8})

            Line()
              .height(1)
              .width('100%')
              .backgroundColor('#E8E8E8')
              .margin({top:15.5})

            Text('简介')
              .fontSize(14)
              .fontWeight(700)
              .fontColor('#121212')
              .margin({top:16})

            Text(this.book.bookContent)
              .fontSize(16)
              .fontWeight(400)
              .lineHeight('140%')
              .fontColor('#7A7A7A')
              .backgroundColor(Color.White)
              .margin({top:8})
          }
          .padding(16)
          .margin({top:8})
          .border({width:2,color:'#F5F5F5',radius:8})
          .alignItems(HorizontalAlign.Center)

        }
        .width('100%')
        .padding({left:24,right:24})
        .margin({bottom:8})
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}