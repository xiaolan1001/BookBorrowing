export class Category {
  id?:number
  categoryName:string
  createUser?:number
  createTime?:string
  updateTime?:string

  constructor(categoryName: string, createUser?: number, createTime?: string, updateTime?:string,id?:number) {
    if(id) this.id = id
    if(createUser) this.createUser = createUser
    if(createTime) this.createTime = createTime
    if(updateTime) this.updateTime = updateTime
    this.categoryName = categoryName
  }
}