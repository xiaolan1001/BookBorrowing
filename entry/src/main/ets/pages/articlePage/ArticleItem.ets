import Article from '../../model/Article'
@Component
export default struct ArticleItem {
  article:Article
  build() {
    Flex({justifyContent:FlexAlign.SpaceBetween,alignItems:ItemAlign.Center}) {
      Image(this.article.coverImg)
        .width(122)
        .height(163)
        .borderRadius(10)

      Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.Center,alignItems:ItemAlign.Start}) {
        Text(this.article.title)
          .fontSize(20)
          .fontWeight(600)
          .fontColor(Color.Black)
          .maxLines(2)
          .textOverflow({overflow:TextOverflow.Ellipsis})
      }
      .width(180)
      .margin({left:15})
    }
    .width('100%')
    .height(200)
    .padding({top:23,bottom:23,left:20,right:20})
    .backgroundColor(Color.White)
    .borderRadius(15)
  }
}