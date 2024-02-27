import router from '@ohos.router'
@Component
export default struct TitleComponent {
  @Prop title:string
  isBack = false
  isNew?:boolean

  back = () => {
    router.back()
  }

  add?: () => void

  build() {
    Flex({justifyContent:FlexAlign.SpaceBetween, alignItems:ItemAlign.Center}) {
      Image(this.isBack ? $r('app.media.ic_button_back') : "")
        .width(20)
        .height(20)
        .objectFit(ImageFit.ScaleDown)
        .onClick(() => {
          this.back()
        })
      Text(this.title)
        .fontColor(Color.Black)
        .fontWeight(400)
        .fontSize(17)

      if(this.isNew) {
        Image($r('app.media.ic_article_add'))
          .width(20)
          .height(20)
          .onClick(() => {
            this.add()
          })
      } else {
        Text("")
      }

    }
    .padding({top:12,bottom:12})
  }
}