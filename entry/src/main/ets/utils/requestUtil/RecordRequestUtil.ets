import axios from '@ohos/axios'
import Config from '../../common/types/Config'
import ResponseModel from '../../model/ResponseModel'
import Record from '../../model/Record'
class RecordRequestUtil {
  postRecord(bookId:number):Promise<ResponseModel<null>> {
    let requestUrl:string = `${Config.baseUrl}/records`
    console.info('info, requestUrl: '+requestUrl)

    return new Promise(async (resolve,reject) => {
      await axios.post(
        requestUrl,
        {
          bookId:bookId
        },
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
            console.log('then, error: '+JSON.stringify(resp))
            reject('Failure')
          }
        })
        .catch(err => {
          console.error('catch, error: '+JSON.stringify(err))
          reject('Failure')
        })
    })
  }

  getRecordList():Promise<ResponseModel<Record[]>> {
    let requestUrl:string = `${Config.baseUrl}/records/list`
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
            console.log('then, error: '+JSON.stringify(resp))
            reject('Failure')
          }
        })
        .catch(err => {
          console.error('catch, error: '+JSON.stringify(err))
          reject('Failure')
        })
    })
  }

  putRecord(recordId:number):Promise<ResponseModel<null>> {
    let requestUrl:string = `${Config.baseUrl}/records/${recordId}`
    console.info('info, requestUrl: '+requestUrl)

    return new Promise(async (resolve,reject) => {
      await axios.put(
        requestUrl,
        null,
        {
          headers:{
            'Authorization':Config.auth,
            'Content-Type':'application/json'
          }
        }
      )
        .then(resp => {
          if(resp.status === 200) {
            console.log('then, resp.data: '+JSON.stringify(resp.data))
            resolve(resp.data)
          } else {
            console.log('then, error: '+JSON.stringify(resp))
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

const recordRequestUtil = new RecordRequestUtil()

export default recordRequestUtil as RecordRequestUtil