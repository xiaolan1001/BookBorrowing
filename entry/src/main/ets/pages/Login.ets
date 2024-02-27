import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import Input from '../common/components/Input'
import MyButton from '../common/components/MyButton'
import User from '../model/User'
import UserRequestUtil from '../utils/requestUtil/UserRequestUtil'
import inputMethodEngine from '@ohos.inputMethodEngine';
import Config from '../common/types/Config'

@Entry
@Component
struct Login {
  @State isRegister:boolean = false
  @State username:string = 'winter'
  @State password:string = '123456'
  //用于按钮文本的父组件传子组件
  @State myButtonText:string = 'Login'

  /**
   * 注册操作
   */
  register() {
    try {
      UserRequestUtil.postUserRegister(this.username, this.password)
        .then(success => {
          if(success.code === 200) {
            promptAction.showToast({message:'注册成功',duration:2000})
            this.isRegister = false
          } else {
            promptAction.showToast({message:success.message,duration:2000})
          }
        })
    } catch (error) {
      console.error('register, error: '+error)
    }
  }

  /**
   * 登录操作
   */
  doLogin() {
    //收起输入法键盘（有问题）
    // inputMethodEngine.getInputMethodAbility().on('inputStart', (kbController, client) => {
    //   let keyboardController = kbController;
    //   let inputClient = client;
    //   keyboardController.hide().then(() => {
    //     console.info('Succeeded in hiding keyboard.');
    //   }).catch((err) => {
    //     console.info('Failed to hide keyboard: ' + JSON.stringify(err));
    //   })
    // })
    //const user = new User(this.username,this.password)
    // console.log('username:'+user.username)
    UserRequestUtil.postUserLogin(this.username,this.password)
      .then(success => {
        if (success.code === 200) {
          Config.auth = success.data //得到鉴权密钥，后续所有请求都应在Headers中加入AUTH
          console.log('Auth'+success.data)
          router.replaceUrl({
            url:'pages/mainPage/Index',
            params:{
              password:this.password
            }
          })
        } else {
          try {
            promptAction.showToast({
              message: success.message,
              duration: 2000,
            });
          } catch (error) {
            console.error(`showToast args error code is ${error.code}, message is ${error.message}`);
          };
        }
      })
  }

  build() {
    //Flex容器多行排列，子组件主轴上的对齐方式为居中，子组件交叉轴上的对齐方式为居中
    Flex({wrap:FlexWrap.Wrap, justifyContent:FlexAlign.Center, alignItems:ItemAlign.Center}) {
      Column() {
        Text(this.isRegister ? 'Sign up':'Login')
          .fontSize(17)
          .fontWeight(400)
          .margin({top:45})
        Line({width:'100%',height:1})
          .backgroundColor(Color.Black)
          .opacity(0.1)
          .margin({top:11.5})
        Text(this.isRegister ? 'Create Your Account':'Login Your Account')
          .fontSize(22)
          .fontWeight(600)
          .margin({top:13.5})
        Text(this.isRegister ? 'Please enter your info for creating account':'Please enter your info for logging account')
          .fontSize(11)
          .fontWeight(400)
          .opacity(0.6)
          .margin({top:4})
      }
      .width('100%')

      Column() {
        Input({
          title: 'Username',
          defaultValue: this.username,
          enterKeyType: EnterKeyType.Next,
          change:(val) => {
            this.username = val
          }
        })

        Input({
          title: 'Password',
          defaultValue: this.password,
          inputType:InputType.Password,
          enterKeyType: EnterKeyType.Send,
          change:(val) => {
            this.password = val
          }
        })
          .margin({top:20})

        MyButton({text:(this.myButtonText = this.isRegister ? 'Sign up':'Login')})
          .margin({top:26})
          .onClick(() => {
            this.isRegister ? this.register():this.doLogin()
          })

        Flex({justifyContent:FlexAlign.Center,alignItems:ItemAlign.Center}) {
          Text(this.isRegister ? 'Already have an account?':'Don’t have an account?')
            .fontSize(13)
            .fontWeight(400)
            .fontColor(Color.Black)
            .opacity(0.6)
          Text(this.isRegister ? 'Login':'Signup')
            .fontSize(13)
            .fontWeight(700)
            .fontColor(Color.Red)
            .opacity(0.6)
            .margin({left:3})
            .onClick(() => {
              this.isRegister = !this.isRegister
            })
        }
        .width('100%')
        .height(16)
        .margin({top:200})
      }
      .width('100%')
      .height('100%')
      .margin({top:151})
      .padding({left:45, right:45})
    }
    .width('100%')
    .height('100%')
  }
}