@Component
export default struct Input {
  //是否聚焦
  @State isFocus:boolean = false
  //标题
  title:string
  //默认值
  defaultValue:string
  //输入类型
  inputType:InputType = InputType.Normal
  //输入法回车键类型
  enterKeyType:EnterKeyType = EnterKeyType.Send

  change = (val:string) => {

  }

  build() {
    Column() {
      Text(this.title)
        .width('100%')
        .textAlign(TextAlign.Start)
        .fontSize(11)
        .fontWeight(400)
        .opacity(0.6)
        .margin({bottom:8.5})
      Flex({alignItems:ItemAlign.Center}) {
        TextInput({
          text:this.defaultValue
        })
          .onFocus(() => {
            this.isFocus = true
          })
          .onBlur(() => {
            this.isFocus = false
          })
          .onChange((val:string) => {
            this.change(val)
          })
          .style(TextInputStyle.Inline)
          .width('100%')
          .type(this.inputType)
          .enterKeyType(this.enterKeyType)
      }
      .height(50)
      .width('100%')
      .borderRadius(10)
      .border({width:this.isFocus ? 1:0,color:'#002884'})
    }
  }
}