@Observed
export default class Article {
  id:number
  title:string
  content:string
  coverImg:string
  createUser:number
  bookId:number
  createTime:string
  updateTime:string

  constructor(id:number,title:string,content:string,coverImg:string,createUser:number,bookId:number,createTime:string,updateTime:string) {
    this.id = id
    this.title = title
    this.content = content
    this.coverImg = coverImg
    this.createUser = createUser
    this.bookId = bookId
    this.createTime = createTime
    this.updateTime = updateTime
  }
}