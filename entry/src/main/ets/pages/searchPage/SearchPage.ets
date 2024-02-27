import router from '@ohos.router'
import TitleComponent from '../../common/components/TitleComponent'
import { Book } from '../../model/Book'
import BookRequestUtil from '../../utils/requestUtil/BookRequestUtil'
import { BookItem } from './BookItem'
@Entry
@Component
struct SearchPage {
  @State text: string = router.getParams()['content']

  @State books:Book[] = []

  aboutToAppear(){
    console.info('info, text: '+this.text)
    this.doSearch()
  }

  /**
   * 查找图书
   */
  doSearch() {
    // TODO 根据标题或内容查找图书
    try {
      BookRequestUtil.searchBook(this.text)
        .then(success => {
          if(success.code === 200) {
            console.log('doSearch, 搜索成功')
            this.books = success.data
          }
        })
    } catch (error) {
      console.error('doSearch, error')
    }
  }

  /**
   * 跳转至图书详情页
   * @param id
   */
  lookBookDetail(id:number) {
    router.pushUrl({
      url:'pages/bookPage/BookPage',
      params:{
        bookId:id
      }
    })
  }

  build() {
    Column() {
      //标题
      TitleComponent({
        title:'查询',
        isBack:true
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
            this.text = val
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

      List({space:24}) {
        ForEach(this.books, (book:Book/*, index:number*/) => {
          ListItem() {
            BookItem({book:book})
              .onClick(() => {
                //对每个ListItem添加点击事件，点击后进入图书详情页
                this.lookBookDetail(book.id)
              })
          }
        })
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1) //填满父组件的剩余空间
    }
    .width('100%')
    .height('100%')
    .padding({left:26,right:26})
    .backgroundColor('#F1F1F1')
  }
}