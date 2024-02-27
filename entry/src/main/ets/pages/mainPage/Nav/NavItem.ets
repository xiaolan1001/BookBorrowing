export class NavItem {
  /**
   * 选中的样式
   */
  selectStyle:string
  /**
   * 默认图片
   */
  defaultImg:Resource

  /**
   * 样式小调
   */
  x:number=0

  isSelect:boolean = false


  constructor(selectStyle:string, defaultImg:Resource, x:number) {
    this.selectStyle = selectStyle
    this.defaultImg = defaultImg
    this.x = x
  }
}