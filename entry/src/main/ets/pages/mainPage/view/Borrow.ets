import TitleComponent from '../../../common/components/TitleComponent'
import { Book } from '../../../model/Book'
import Record from '../../../model/Record'
import BookRequestUtil from '../../../utils/requestUtil/BookRequestUtil'
import RecordRequestUtil from '../../../utils/requestUtil/RecordRequestUtil'
import { BorrowItem } from '../../borrowPage/BorrowItem'
import { BookItem } from '../../searchPage/BookItem'
@Component
export default struct Borrow {
  @State refreshing: boolean = false;
  @State records:Record[] = []

  aboutToAppear() {
    try {
      RecordRequestUtil.getRecordList()
        .then(success => {
          if(success.code === 200) {
            this.records = success.data
            this.records.reverse()
          }
        })
    } catch (error) {
      console.error('aboutToAppear, error: '+error)
    }
  }

  build() {
    Column() {
      //标题
      TitleComponent({
        title:'借阅'
      })

      Flex({direction:FlexDirection.Column,justifyContent:FlexAlign.Start}) {
        List({space:24}) {
          ForEach(this.records, (record:Record) => {
            ListItem() {
              BorrowItem({record:record})
            }
          })
        }
        .width('100%')
        .height(700)
      }
      .width('100%')
      .height('100%')

      // List({space:24}) {
      //   ForEach(this.records, (record:Record) => {
      //     ListItem() {
      //       BorrowItem({record:record})
      //     }
      //   })
      // }
      // .width('100%')
      // .padding({bottom:58})

      // Refresh({refreshing:this.refreshing}) {
      //   List({space:24}) {
      //     ForEach(this.records, (record:Record) => {
      //       ListItem() {
      //         BorrowItem({record:record})
      //       }
      //     })
      //   }
      //   .width('100%')
      //   .padding({bottom:58})
      // }
      // .onRefreshing(() => {
      //   this.refreshing = true;    // 进入刷新状态
      //   try {
      //     RecordRequestUtil.getRecordList()
      //       .then(success => {
      //         if(success.code === 200) {
      //           this.records = success.data
      //           this.refreshing = false
      //         }
      //       })
      //   } catch (error) {
      //     console.error('aboutToAppear, error: '+error)
      //   } finally {
      //     this.refreshing = false
      //   }
      // })
    }
    .width('100%')
    // .margin({bottom:58})
  }
}