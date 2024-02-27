import promptAction from '@ohos.promptAction'
import Input from '../../../common/components/Input'
import User from '../../../model/User'
import userRequestUtil from '../../../utils/requestUtil/UserRequestUtil'
@CustomDialog
export struct UserDialog {
  controller:CustomDialogController

  @Link currentUser:User

  getCardOptions() {
    return [{value:'中原银行(xxxxx)'}]
  }

  /**
   * 关闭弹窗
   */
  closeDialog() {
    this.controller.close()
  }

  /**
   * 向服务器发送请求更新个人信息
   */
  updateInfo() {
    try {
      userRequestUtil.putUserInfo(this.currentUser)
        .then(success => {
          if(success.code === 200) {
            promptAction.showToast({message:'修改成功',duration:2000})
          } else {
            promptAction.showToast({message:success.message,duration:2000})
          }
        })
        .catch(failure => {
          promptAction.showToast({message:failure,duration:2000})
        })
    } finally {
      this.closeDialog()
    }
    /*catch (error) {
      console.error('try, catch: '+error)
    }*/
  }

  build() {
    Flex({direction:FlexDirection.Column, alignItems:ItemAlign.Center}) {
      Text('Information')
        .fontSize(20)
        .fontWeight(500)
        .padding({top:24, bottom:11.5})
        .textAlign(TextAlign.Center)
        .width('100%')
        .border({width:{bottom:1}, color:'rgba(0,0,0,0.1)'})

      Column({space:15}) {
        Flex({direction:FlexDirection.Column}) {
          Text('Username')
            .fontSize(13)
            .fontWeight(400)
            .fontColor('rgba(0,0,0,0.6)')
          TextInput({
            text:this.currentUser.username
          })
            .fontSize(18)
            .fontWeight(400)
            .fontColor(Color.Black)
            .margin({top:2})
            .padding(0)
            .backgroundColor(Color.White)
            .onChange((value) => {
              this.currentUser.username = value
            })
        }
        .padding({top:7,bottom:7,left:13,right:10})
        .width('100%')
        .height(60)
        .border({width:1,color:'rgba(0,0,0,0.4)',radius:6})
        .backgroundColor(Color.White)

        Flex({direction:FlexDirection.Column}) {
          Text('Nick Name')
            .fontSize(13)
            .fontWeight(400)
            .fontColor('rgba(0,0,0,0.6)')
          TextInput({
            // placeholder:this.currentUser.nickname?'':'To be set',
            text:this.currentUser.nickname?this.currentUser.nickname:''
          })
            .fontSize(18)
            .fontWeight(400)
            .fontColor(Color.Black)
            .margin({top:2})
            .padding(0)
            .backgroundColor(Color.White)
            .onChange((value) => {
              this.currentUser.nickname = value
            })
        }
        .padding({top:7,bottom:7,left:13,right:10})
        .width('100%')
        .height(60)
        .border({width:1,color:'rgba(0,0,0,0.4)',radius:6})
        .backgroundColor(Color.White)

        Flex({direction:FlexDirection.Column}) {
          Text('Email')
            .fontSize(13)
            .fontWeight(400)
            .fontColor('rgba(0,0,0,0.6)')
          TextInput({
            // placeholder:this.currentUser.email?'':'To be set',
            text:this.currentUser.email?this.currentUser.email:''
          })
            .fontSize(18)
            .fontWeight(400)
            .fontColor(Color.Black)
            .type(InputType.Email)
            .margin({top:2})
            .padding(0)
            .backgroundColor(Color.White)
            .onChange((value) => {
              this.currentUser.email = value
            })
        }
        .padding({top:7,bottom:7,left:13,right:10})
        .width('100%')
        .height(60)
        .border({width:1,color:'rgba(0,0,0,0.4)',radius:6})
        .backgroundColor(Color.White)
      }
      .width('100%')
      .margin({top:55})

      Button('Confirm')
        .fontSize(20)
        .fontColor(Color.White)
        .width('100%')
        .height(51)
        .backgroundColor(Color.Black)
        .shadow({radius:1,color:'rgba(0,0,0,0.4)',offsetX:4,offsetY:2})
        .margin({top:40})
        .onClick(() => {
          this.updateInfo()
        })
    }
    .width('100%')
    .height('80%')
    .padding({left:25,right:25})
    .backgroundColor('#F1F1F1')
    //.margin({top:92})
    .borderRadius({
      topLeft:30,
      topRight:30
    })
  }
}