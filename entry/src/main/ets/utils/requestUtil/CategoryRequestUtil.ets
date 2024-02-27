import axios from '@ohos/axios'
import Config from '../../common/types/Config'
import { Category } from '../../model/Category'
import ResponseModel from '../../model/ResponseModel'
class CategoryRequestUtil {
  getCategory(id:number):Promise<ResponseModel<Category>> {
    let requestUrl:string = `${Config.baseUrl}/categories/${id}`
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
}

const categoryRequestUtil = new CategoryRequestUtil()
export default categoryRequestUtil as CategoryRequestUtil