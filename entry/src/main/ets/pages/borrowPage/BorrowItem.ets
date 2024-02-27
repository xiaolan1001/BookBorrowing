import promptAction from '@ohos.promptAction'
import { Book } from '../../model/Book'
import Record from '../../model/Record'
import BookRequestUtil from '../../utils/requestUtil/BookRequestUtil'
import RecordRequestUtil from '../../utils/requestUtil/RecordRequestUtil'
@Component
export struct BorrowItem {
  record:Record
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

  aboutToAppear() {
    this.getBook()
  }

  getBook() {
    try {
      BookRequestUtil.searchBookById(this.record.bookId)
        .then(success => {
          if(success.code === 200) {
            this.book = success.data
          }
        })
    } catch (error) {
      console.error('getBook, error')
    }
  }

  returnBook() {
    try {
      RecordRequestUtil.putRecord(this.record.id)
        .then(success => {
          if(success.code === 200) {
            console.log('归还成功')
            promptAction.showToast({message:'归还成功',duration:2000})
          } else {
            promptAction.showToast({message:success.message,duration:2000})
          }
        })
    } catch (error) {
      console.error('returnBook, error')
    }
  }

  build() {
    Flex({justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Center}) {
      Image(this.book.bookCoverImg)
        .width(122)
        .height(163)
        .borderRadius(10)

      Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.Center,alignItems:ItemAlign.Start}) {
        Text(this.book.title)
          .fontSize(20)
          .fontWeight(600)
          .fontColor(Color.Black)
        Text(this.book.author)
          .fontSize(17)
          .fontWeight(400)
          .fontColor('rgba(0,0,0,0.4)')
          .margin({top:9})
        Text(this.record.borrowTime)
          .fontSize(14)
          .fontWeight(400)
          .fontColor('rgba(0,0,0,0.4)')
          .margin({top:9})
        if(this.record.state) {
          Text(`归还时间：${this.record.returnTime}`)
            .fontSize(14)
            .fontWeight(400)
            .fontColor('rgba(0,0,0,0.4)')
            .margin({top:9})
        } else {
          Flex() {
            Text('暂未归还')
              .fontSize(14)
              .fontWeight(400)
              .fontColor('rgba(0,0,0,0.4)')
            Text('归还')
              .fontSize(14)
              .fontWeight(400)
              .fontColor('rgba(255,0,0,0.6)')
              .margin({left:9})
              .onClick(() => {
                this.returnBook()
              })
          }
          .margin({top:9})
        }
      }
      .margin({left:15})
    }
    .width('100%')
    .height(200)
    .padding({top:23,bottom:23,left:20,right:20})
    .backgroundColor(Color.White)
    .borderRadius(15)
  }
}