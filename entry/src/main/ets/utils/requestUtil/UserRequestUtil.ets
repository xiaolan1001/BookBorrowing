import axios, { FormData } from '@ohos/axios'
import http from '@ohos.net.http'
import Config from '../../common/types/Config'
import ResponseModel from '../../model/ResponseModel'
import User from '../../model/User'
class UserRequestUtil {
  baseURL:string = Config.baseUrl.toString()

  postUserRegister(username:string, password:string):Promise<ResponseModel<null>> {
    let requestUrl:string = `${Config.baseUrl}/user/register`
    console.info('info, requestUrl: '+requestUrl)
    return new Promise(async (resolve, reject) => {
      await axios.post(
        requestUrl,
        {
          username:username,
          password:password
        },
        {
          headers:{
            'Content-Type':'application/x-www-form-urlencoded'
          }
        }
      )
        .then(resp => {
          if(resp.status === 200) {
            console.log('then, resp.data: '+JSON.stringify(resp.data))
            resolve(resp.data)
          } else {
            console.log('then, failure: '+JSON.stringify(resp))
            reject(resp)
          }
        })
        .catch(err => {
          console.error('catch, error: '+JSON.stringify(err))
          reject(err)
        })
    })
  }

   postUserLogin(username,password):Promise<ResponseModel<string>> {
    return new Promise(async (resolve, reject) => {
      await axios.post(
        `${this.baseURL}/user/login`,
        {
          username:username,
          password:password
        },
        {
          headers: {'Content-Type': 'application/x-www-form-urlencoded'}
        }
      )
        .then(resp => {
          if(resp.status === 200) {
            //登录成功
            console.log('OK', JSON.stringify(resp.data))
            resolve(resp.data)
          } else {
            console.log('ERROR:用户登录失败', JSON.stringify(resp))
            reject('error')
          }
        })
        .catch(error => {
          console.log('ERROR:用户登录失败', JSON.stringify(error))
        })
    })
  }

  loadPersonInfo():Promise<User> {
    return new Promise((resolve, reject) => {
      axios.get(
        `${this.baseURL}/user/info`,
        {
          headers:{
            'Authorization':Config.auth
          }
        }
      )
        .then(resp => {
          if(resp.status === 200) {
            //查询成功
            console.log('获取个人信息数据成功：',JSON.stringify(resp.data))
            let responseModel:ResponseModel<User> = resp.data
            resolve(responseModel.data)
          } else {
            console.error('获取个人信息数据失败：',JSON.stringify(resp))
            reject('获取个人信息数据失败')
          }
        })
        .catch(error => {
          console.error('获取个人信息数据失败：',JSON.stringify(error))
          reject('获取个人信息数据失败')
        })
    })
  }

  /**
   * 更新当前登录用户密码
   * {
   *   "oldPwd": "string",
   *   "newPwd": "string", //简便操作，不再要求用户重新输入一遍密码
   *   "rePwd": "string"
   * }
   */
  updatePassword(data:any):Promise<ResponseModel<null>> {
    return new Promise(async (resolve, reject) => {
      await axios.put(
        `${this.baseURL}/user/password`,
        data,
        {
          headers:{
            'Content-Type':'application/json',
            'Authorization':Config.auth
          }
        }
      )
        .then(resp => {
          if(resp.status === 200) {
            console.log('修改密码成功',JSON.stringify(resp.data))
            resolve(resp.data)
          } else {
            console.error('修改密码失败',JSON.stringify(resp))
            reject('修改密码失败')
          }
        })
        .catch(error => {
          console.error('修改密码失败',JSON.stringify(error))
          reject('修改密码失败')
        })
    })
  }

  /**
   * 根据id更新指定用户基本信息
   * @param user
   * @returns
   */
  putUserInfo(user:User):Promise<ResponseModel<null>> {
    return new Promise(async (resolve, reject) => {
      let requestUrl:string = `${Config.baseUrl}/user/${user.id}`
      console.info('info, requestUrl: '+requestUrl)

      await axios.put(
        requestUrl,
        {
          username:user.username,
          nickname:user.nickname,
          email:user.email
        },
        {
          headers:{
            'Authorization':Config.auth
          }
        }
      )
        .then(response => {
          if(response.status === 200) {
            console.log('then, success: '+JSON.stringify(response.data))
            resolve(response.data)
          } else {
            console.log('then, failure: '+JSON.stringify(response))
            reject('Failure')
          }
        })
        .catch(error => {
          console.error('catch, failure: '+JSON.stringify(error))
          reject('Failure')
        })
    })
  }
}

const userRequestUtil = new UserRequestUtil()

export  default userRequestUtil as UserRequestUtil