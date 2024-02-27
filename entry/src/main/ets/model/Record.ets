export default class Record {
  id?:number
  userId?:number
  bookId?:number
  state?:boolean
  borrowTime?:string
  returnTime?:string

  constructor(id?:number,
  userId?:number,
  bookId?:number,
  state?:boolean,
  borrowTime?:string,
  returnTime?:string) {
    if(id) this.id = id
    if(userId) this.userId = userId
    if(bookId) this.bookId = bookId
    if(state) this.state = state
    if(borrowTime) this.borrowTime = borrowTime
    if(returnTime) this.returnTime = returnTime
  }
}