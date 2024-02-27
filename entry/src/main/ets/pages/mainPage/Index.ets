import router from '@ohos.router'
import User from '../../model/User'
import { NavBar } from './Nav/NavBar'
import ArticleView from './view/ArticleView'
import Borrow from './view/Borrow'
import Home from './view/Home'
import Profile from './view/Profile'
@Entry
@Component
struct MainPage {
  @State currentIndex:number = 0
  @State currentUser:User = {
    id:1,
    username:'winter',
    password:router.getParams()['password'],
    nickname:'Winter',
    email:'2567660544@qq.com',
    updateTime:'2024-02-05 18:54:10'
  }

  onPageShow() {
    router.clear()
  }

  build() {
    Column() {
      Scroll() {
        if(this.currentIndex === 0) {
          //首页
          Home()
        }

        if(this.currentIndex === 1) {
          //文章
          ArticleView()
        }

        if(this.currentIndex === 2) {
          //借阅
          Borrow()
        }

        if(this.currentIndex === 3) {
          //个人中心
          Profile({currentUser:$currentUser})
        }
      }
      .scrollBar(BarState.Off)
      //.padding({bottom:100})
      //底部导航栏
      NavBar({
        currentIndex:$currentIndex
      })
        .border({width:{top:1},color:'rgba(0,0,0,0.1)'})
        .offset({y:-58})
    }
    .height('100%')
    .backgroundColor('#F1F1F1')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}