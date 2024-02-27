import router from '@ohos.router'
import Config from '../../../common/types/Config'
import Article from '../../../model/Article'
import { fileSelect, updateImageUrl, upload } from '../../../utils/imageUtil/ImageUtil'
import ArticleRequestUtil from '../../../utils/requestUtil/ArticleRequestUtil'
@Component
export default struct EditArticle {
  bookId:number
  title?:string
  content?:string
  coverImg?:string
  @State article:Article = {
    id:1,
    title:'title',
    content:'content',
    coverImg:'coverImg',
    createUser:1,
    bookId:1,
    createTime:'createTime',
    updateTime:'updateTime'
  }

  aboutToAppear() {
    if(this.title) this.article.title = this.title
    if(this.content) this.article.content = this.content
    if(this.coverImg) this.article.coverImg = this.coverImg
    this.article.bookId = this.bookId
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
          this.article.coverImg = `${Config.aliOSS}${success}.jpg`
        })
    })
  }

  uploadArticle() {
    try {
      ArticleRequestUtil.postArticle(this.article)
        .then(success => {
          if(success.code === 200) {
            console.log('uploadArticle, success')
            router.pushUrl(
              {
                url:'pages/mainPage/Index'
              },
              router.RouterMode.Single
            )
          }
        })
    } catch (error) {
      console.error('uploadArticle, error: '+JSON.stringify(error))
    }
  }

  build() {
    Column() {
      Column({space:15}) {
        Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}) {
          Text('Image')
            .fontSize(13)
            .fontWeight(400)
            .fontColor('rgba(0,0,0,0.6)')
          Image(this.article.coverImg)
            .width(183)
            .height(271)
            .borderRadius(7)
            .margin({top:9})
            .border({width:1,color:'rgba(0,0,0,0.4)'})
            .onClick(() => {
              this.updateAvatar()
            })
        }
        .padding({top:7,bottom:7,left:13,right:10})
        .width('100%')
        .backgroundColor(Color.White)
        .borderRadius(6)

        Flex({direction:FlexDirection.Column}) {
          Text('Title')
            .fontSize(13)
            .fontWeight(400)
            .fontColor('rgba(0,0,0,0.6)')
          TextInput({
            text:this.article.title
          })
            .fontSize(18)
            .fontWeight(400)
            .fontColor(Color.Black)
            .margin({top:2})
            .padding(0)
            .backgroundColor(Color.White)
            .onChange((value) => {
              this.article.title = value
            })
        }
        .padding({top:7,bottom:7,left:13,right:10})
        .width('100%')
        .height(60)
        .border({width:1,color:'rgba(0,0,0,0.4)',radius:6})
        .backgroundColor(Color.White)

        Flex({direction:FlexDirection.Column}) {
          Text('Content')
            .fontSize(13)
            .fontWeight(400)
            .fontColor('rgba(0,0,0,0.6)')
          TextArea({
            text:this.article.content
          })
            .fontSize(18)
            .fontWeight(400)
            .fontColor(Color.Black)
            .margin({top:2})
            .padding(0)
            .backgroundColor(Color.White)
            .onChange((value) => {
              this.article.content = value
            })
        }
        .padding({top:7,bottom:7,left:13,right:10})
        .width('100%')
        .height(500)
        .border({width:1,color:'rgba(0,0,0,0.4)',radius:6})
        .backgroundColor(Color.White)
      }
      .width('100%')
      .margin({top:55})

      Button('Publish')
        .fontSize(20)
        .fontColor(Color.White)
        .width('100%')
        .height(51)
        .backgroundColor(Color.Black)
        .shadow({radius:1,color:'rgba(0,0,0,0.4)',offsetX:4,offsetY:2})
        .margin({top:40})
        .onClick(() => {
          this.uploadArticle()
        })
    }
    .width('100%')
    .padding({left:26,right:26})
    .backgroundColor('#F1F1F1')
  }
}