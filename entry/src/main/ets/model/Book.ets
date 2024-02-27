export class Book {
  id?:number
  title:string
  author:string
  isbn:string
  bookContent:string
  bookCoverImg:string
  publisher:string
  availableCopies:number
  totalCopies:number
  categoryId?:number
  createUser?:number
  createTime?:string
  updateTime?:string

  constructor(title:string, author:string, isbn:string, bookContent:string, bookCoverImg:string,
  publisher:string, availableCopies:number, totalCopies:number, categoryId?:number, createUser?:number,
  createTime?:string, updateTime?:string,id?:number) {
    if(id)this.id = id
    this.title = title
    this.author = author
    this.isbn = isbn
    this.bookContent = bookContent
    this.bookCoverImg = bookCoverImg
    this.publisher = publisher
    this.availableCopies = availableCopies
    this.totalCopies = totalCopies
    if(categoryId) this.categoryId = categoryId
    if(createUser) this.createUser = createUser
    if(createTime) this.createTime = createTime
    if(updateTime) this.updateTime = updateTime
  }
}