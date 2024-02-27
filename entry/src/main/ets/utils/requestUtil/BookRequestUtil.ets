import axios from '@ohos/axios'
import Config from '../../common/types/Config'
import { Book } from '../../model/Book'
import ResponseModel from '../../model/ResponseModel'
class BookRequestUtil {
  searchBook(content:string):Promise<ResponseModel<Book[]>> {
    let requestUrl:string = `${Config.baseUrl}/books/search`
    console.info('info, requestUrl: '+requestUrl)
    return new Promise(async (resolve,reject) => {
      await axios.get(
        requestUrl,
        {
          params:{
            content:content
          },
          headers:{
            'Authorization':Config.auth
          }
        }
      )
        .then(resp => {
          if(resp.status === 200) {
            console.log('then, resp.data: '+JSON.stringify(resp.data))
            resolve(resp.data)
          } else {
            console.log('then, failure: '+JSON.stringify(resp))
            reject('Failure')
          }
        })
        .catch(err => {
          console.error('catch, error: '+JSON.stringify(err))
          reject('Failure')
        })
    })
  }

  searchBookById(bookId:number):Promise<ResponseModel<Book>> {
    let requestUrl:string = `${Config.baseUrl}/books/${bookId}`
    console.info('info, requestUrl: '+requestUrl)
    return new Promise(async (resolve,reject) => {
      await axios.get(
        requestUrl,
        {
          headers:{
            'Authorization':Config.auth
          }
        }
      )
        .then(resp => {
          if(resp.status === 200) {
            console.log('then, resp.data: '+JSON.stringify(resp.data))
            resolve(resp.data)
          } else {
            console.log('then, failure: '+JSON.stringify(resp))
            reject('Failure')
          }
        })
        .catch(err => {
          console.error('catch, error: '+JSON.stringify(err))
          reject('Failure')
        })
    })
  }
}

const bookRequestUtil = new BookRequestUtil()
export default bookRequestUtil as BookRequestUtil