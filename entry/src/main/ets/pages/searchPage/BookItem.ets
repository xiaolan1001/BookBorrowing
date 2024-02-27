import { Book } from '../../model/Book'
@Component
export struct BookItem {
  book:Book
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
        Text(this.book.bookContent)
          .fontSize(14)
          .fontWeight(400)
          .fontColor('rgba(0,0,0,0.4)')
          .maxLines(3)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .margin({top:15})
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