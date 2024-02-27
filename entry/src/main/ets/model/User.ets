// @Observed //User类没有嵌套对象，也不会创建数组，故无需使用该装饰器
export default class User {
  id?:number
  username:string
  password:string
  nickname?:string
  email?:string
  userPic?:string
  createTime?:string
  updateTime?:string

  constructor(username:string,password:string,
              id?:number,nickname?:string,email?:string,userPic?:string,createTime?:string,updateTime?:string) {
    this.username = username
    this.password = password
    if(nickname) this.nickname = nickname
    if(email) this.email = email
    if(userPic) this.userPic = userPic
    if(id) this.id = id
    if(createTime) this.createTime = createTime
    if(updateTime) this.updateTime = updateTime
  }
}