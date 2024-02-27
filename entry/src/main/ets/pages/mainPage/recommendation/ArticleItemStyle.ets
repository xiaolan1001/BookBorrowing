import Article from '../../../model/Article'
@Component
export default struct ArticleItemStyle {
  article:Article

  build() {
    Column() {
      Image(this.article.coverImg)
        .width(122)
        .height(163)
        .borderRadius(10)
        .objectFit(ImageFit.ScaleDown)

      Text(this.article.title)
        .fontSize(12)
        .fontWeight(600)
        .fontColor(Color.Black)
        .margin({top:16})
        .maxLines(2)
        .textOverflow({overflow:TextOverflow.Ellipsis})
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}