import { NavItem } from './NavItem'
@Component
export default struct NavBarStyle {
  navBarItem:NavItem

  @Prop isSelect:boolean

  build() {
    Column() {
      if(this.isSelect) {
        Flex({justifyContent:FlexAlign.Center, alignItems:ItemAlign.Center}) {
          Stack() {
            Text(this.navBarItem.selectStyle)
              .fontSize(12)
              .fontWeight(400)
              .fontColor(Color.Black)
            Text('.')
              .fontSize(35)
              .fontWeight(400)
              .fontColor(Color.Black)
              .margin({top:2})
          }
        }
        .width('100%')
        .height(58)
      } else {
        Image(this.navBarItem.defaultImg)
          .width(25)
          .height(25)
          .interpolation(ImageInterpolation.High)
      }
    }
    .width('100%')
    .height(58)
    .justifyContent(FlexAlign.Center)
  }
}