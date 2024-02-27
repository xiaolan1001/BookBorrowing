import promptAction from '@ohos.promptAction'
import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import TitleComponent from '../../../common/components/TitleComponent'
import User from '../../../model/User'
import UserRequestUtil from '../../../utils/requestUtil/UserRequestUtil'
import abilityAccessCtrl from '@ohos.abilityAccessCtrl'
import picker from '@ohos.file.picker'
import bundleManager from '@ohos.bundle.bundleManager'
import Config from '../../../common/types/Config'
import request from '@ohos.request'
import UploadFileUtil from '../../../utils/imageUtil/UploadFileUtil'
import { fileSelect, updateImageUrl, upload } from '../../../utils/imageUtil/ImageUtil'
import { UserDialog } from '../userInfo/UserDialog'
@Component
export default struct Profile {
  @Link currentUser:User

  /**
   * 密码组件是否可以编辑
   */
  @State isChange:boolean = false

  @State modifiedPwd:string = ''

  dialogController = new CustomDialogController({
    builder:UserDialog({currentUser:$currentUser}),
    alignment:DialogAlignment.Bottom,
    customStyle:true
  })

  mediaMessage:string

  aboutToAppear() {
    //加载个人信息
    this.getPersonInfo()
  }

  // 在自定义组件即将析构销毁时将dialogController置空
  aboutToDisappear() {
    this.dialogController = null // 将dialogController置空
  }

  getPersonInfo() {
    UserRequestUtil.loadPersonInfo()
      .then(success => {
        // this.currentUser = success
        //此处特别要注意success返回的password字段为空，所以不能直接赋值给this.currentUser对象
        this.currentUser.id = success.id
        this.currentUser.username = success.username
        this.currentUser.nickname = success.nickname
        this.currentUser.userPic = success.userPic
        this.currentUser.email = success.email
        this.currentUser.createTime = success.createTime
        this.currentUser.updateTime = success.updateTime
      })

    //此处更改日期格式有问题，待解决
    // let dateString:string = this.currentUser.updateTime.slice(0,10).toString()
    // console.log('dateString:'+dateString)
    // let date = new Date(dateString)
    // console.log('date:'+(date.getMonth()+1 < 12 ? date.getMonth()+1:12))
    // this.currentUser.updateTime = `${date.getFullYear()}年${date.getMonth()+1 < 12 ? date.getMonth()+1:12}月${date.getDate()}日`
  }

  modifyPassword() {
    //调用网络请求工具类的方法向服务器请求更新密码
    // let user:User = new User('','')
    // user = this.currentUser
    console.info('password:'+this.currentUser.password+', '+this.modifiedPwd)
    UserRequestUtil.updatePassword(
      {
        oldPwd:`${this.currentUser.password}`,
        newPwd:`${this.modifiedPwd}`,
        rePwd:`${this.modifiedPwd}`
      }
    )
      .then(success => {
        if(success.code === 200) {
          try {
            promptAction.showToast({
              message: '修改成功，返回登录界面',
              duration: 2000,
            });

            router.replaceUrl({
              url:'pages/Login'
            })
          } catch (error) {
            console.error(`showToast args error code is ${error.code}, message is ${error.message}`);
          }
        } else {
          try {
            promptAction.showToast({
              message: success.message,
              duration: 2000,
            });
          } catch (error) {
            console.error(`showToast args error code is ${error.code}, message is ${error.message}`);
          }
        }
      })
  }

  updateAvatar() {
    //1.打开相册选择图片
    //媒体访问权限属于 user_grant 类型，需要再运行时动态向用户授权，
    //因此需要调用 @ohos.abilityAccessCtrl 模块的 requestPermissionsFromUser() 方法向用户授权
    //await UploadFileUtil.requestMediaPermission()
    // this.openGallery()

    //2.上传文件至阿里云OSS存储，并得到返回的URL地址

    //3.向服务器发送更新请求

    fileSelect().then((uri:string) => {
      upload(getContext(this),uri,(data) => {
        console.log('成功啦！')
      })
        .then(success => {
          console.log(success.toString())
          this.currentUser.userPic = `${Config.aliOSS}${success}.jpg`
          updateImageUrl(this.currentUser.userPic)
        })
    })
  }

  build() {
    Column() {
      //标题
      TitleComponent({
        title:'个人中心'
      })

      Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}) {
        Stack() {
          Image(this.currentUser.userPic)
            .width(122)
            .height(122)
            .borderRadius(122)
            .alt($r('app.media.ic_profile_avatar'))
            .interpolation(ImageInterpolation.High)
          Flex({justifyContent:FlexAlign.Center,alignItems:ItemAlign.Center}) {
            Image($r('app.media.ic_profile_avatar_edit'))
              .width(22)
              .height(22)
              .interpolation(ImageInterpolation.High)
          }
          .width(34)
          .height(34)
          .borderRadius(34)
          .backgroundColor('#1E1E1E')
          .border({width:4,color:Color.White})
          .offset({x:-35,y:42})
        }
        .onClick(() => {
          //点击头像更换头像
          this.updateAvatar()
        })
        Text(this.currentUser.nickname?this.currentUser.nickname:'To be set')
          .fontSize(20)
          .fontWeight(400)
          .fontColor(Color.Black)
          .margin({top:17})

        Text(this.currentUser.email?this.currentUser.email:'To be set')
          .fontSize(15)
          .fontWeight(400)
          .fontColor('rgba(0,0,0,0.4)')
          .margin({top:1})

        Flex({justifyContent:FlexAlign.Center,alignItems:ItemAlign.Center}) {
          Flex({alignItems:ItemAlign.Center}) {
            Image($r('app.media.ic_nav_profile'))
              .width(25)
              .height(25)
              .interpolation(ImageInterpolation.High)
            Text('Personal info')
              .fontSize(13)
              .fontWeight(400)
              .margin({left:2})
          }
          .margin({top:25})
        }

        Column({space:15}) {
          Flex({direction:FlexDirection.Column}) {
            Text('Username')
              .fontSize(10)
              .fontWeight(400)
              .fontColor('rgba(0,0,0,0.6)')
            Text(this.currentUser.username)
              .fontSize(13)
              .fontWeight(400)
              .fontColor(Color.Black)
              .margin({top:2})
          }
          .padding({top:7,bottom:7,left:13,right:10})
          .width('100%')
          .height(44)
          .border({width:1,color:'rgba(0,0,0,0.4)',radius:6})

          Flex({direction:FlexDirection.Column}) {
            Text('Nick Name')
              .fontSize(10)
              .fontWeight(400)
              .fontColor('rgba(0,0,0,0.6)')
            Text(this.currentUser.nickname?this.currentUser.nickname:'To be set')
              .fontSize(13)
              .fontWeight(400)
              .fontColor(Color.Black)
              .margin({top:2})
          }
          .padding({top:7,bottom:7,left:13,right:10})
          .width('100%')
          .height(44)
          .border({width:1,color:'rgba(0,0,0,0.4)',radius:6})

          Flex({alignItems:ItemAlign.Center}) {
            Flex({direction:FlexDirection.Column/*,justifyContent:FlexAlign.Start*/}) {
              Text('Password')
                .fontSize(10)
                .fontWeight(400)
                .fontColor('rgba(0,0,0,0.6)')
              TextInput(/*{text:this.currentUser.password}*/)
                .caretColor(Color.Black)
                .type(InputType.Password)
                .enabled(this.isChange)
                // .style(TextInputStyle.Inline)
                .showPasswordIcon(false)
                .fontSize(13)
                .padding(0)
                .margin({top:2})
                .backgroundColor(Color.White)
                .onChange((value:string) => {
                  this.modifiedPwd = value
                  console.log("modifiedPwd:"+this.modifiedPwd)
                })
            }
            .width('100%')
            .height('100%')

            Text(this.isChange?'Confirm':'Change')
              .fontSize(11)
              .fontColor('rgba(255,0,0,0.6)')
              .width(54)
              .margin({left:2})
              .onClick(() => {
                if(this.isChange) {
                  //当前处于修改模式，文本显示为Confirm，即待确认
                  //此时isChange布尔值要置反（在下面代码置反），同时弹窗再次确认，调用修改密码函数
                  AlertDialog.show({
                    message:'Confirm modification？',
                    primaryButton:{
                      value:'Cancel',
                      fontColor:'rgba(255,0,0,0.6)',
                      action:()=>{}
                    },
                    secondaryButton:{
                      value:'Confirm',
                      fontColor:Color.Black,
                      action:()=>{
                        //修改密码，并且应该回到登录界面
                        this.modifyPassword()
                      }
                    }
                  })
                }
                this.isChange = !this.isChange
              })
          }
          .padding({top:7,bottom:7,left:13,right:10})
          .width('100%')
          .height(44)
          .border({width:1,color:'rgba(0,0,0,0.4)',radius:6})

          Flex({direction:FlexDirection.Column}) {
            Text('Email')
              .fontSize(10)
              .fontWeight(400)
              .fontColor('rgba(0,0,0,0.6)')
            Text(this.currentUser.email?this.currentUser.email:'To be set')
              .fontSize(13)
              .fontWeight(400)
              .fontColor(Color.Black)
              .margin({top:2})
          }
          .padding({top:7,bottom:7,left:13,right:10})
          .width('100%')
          .height(44)
          .border({width:1,color:'rgba(0,0,0,0.4)',radius:6})

          Button('Change')
            .fontSize(20)
            .fontColor('rgba(255,0,0,0.6)')
            .width('100%')
            .height(51)
            .backgroundColor('#F1F1F1')
            // .backgroundColor(Color.White)
            .shadow({radius:1,color:'rgba(0,0,0,0.4)',offsetX:4,offsetY:2})
            .margin({top:40})
            .onClick(() => {
              this.dialogController.open()
            })

          Flex({direction:FlexDirection.Column,alignItems:ItemAlign.End}) {
            Text('上次修改时间：')
              .fontSize(10)
              .fontWeight(400)
              .fontColor('rgba(0,0,0,0.6)')
            Text(this.currentUser.updateTime)
              .fontSize(13)
              .fontWeight(400)
              .fontColor(Color.Black)
              .margin({top:2})
          }
          .width('100%')
          .height(44)
          .margin({top:5})
        }
        .margin({top:15})

      }.width('100%')
      .margin({top:31})

    }
    .height('100%')
    .padding({left:45,right:45})
    .backgroundColor(Color.White)
  }
}