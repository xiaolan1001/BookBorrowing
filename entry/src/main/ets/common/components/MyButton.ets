@Component
export default struct MyButton {
  @Prop text:string

  build() {
    Flex({justifyContent:FlexAlign.Center}) {
      Text(this.text)
        .width(300)
        .height(51)
        .fontSize(20)
        .fontWeight(400)
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .borderRadius(100)
        .backgroundColor('#1E1E1E')
    }
    .width('100%')
    .height(51)
  }
}