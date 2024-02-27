import NavBarStyle from './NavBarStyle'
import { NavItem } from './NavItem'
@Component
export struct NavBar {
  @Link currentIndex:number

  nav:NavItem[] = [
    new NavItem('Home',$r('app.media.ic_nav_home'), 0),
    new NavItem('Article',$r('app.media.ic_book_share'), 0),
    new NavItem('Borrow',$r('app.media.ic_nav_borrow'), 0),
    new NavItem('Profile',$r('app.media.ic_nav_profile'),0)
  ]

  build() {
    Flex() {
      ForEach(this.nav, (item:NavItem, index:number) => {
        NavBarStyle({navBarItem:item, isSelect:this.currentIndex === index})
          .offset({x:item.x})
          .onClick(() => {
            this.currentIndex = index
            console.log(index+'',this.currentIndex)
          })
      })
    }
    .width('100%')
    .height(58)
    .backgroundColor(Color.White)
  }
}