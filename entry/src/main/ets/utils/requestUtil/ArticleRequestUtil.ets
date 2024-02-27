import axios from '@ohos/axios'
import Config from '../../common/types/Config'
import Article from '../../model/Article'
import ResponseModel from '../../model/ResponseModel'

interface JSONObject {
  total:string
  items:Article[]
}

class ArticleRequestUtil {
  baseURL:string = Config.baseUrl

  getRecommendation(pageNum:number,pageSize:number):Promise<ResponseModel<JSONObject>> {
    return new Promise((resolve,reject) => {
      axios.get(
        `${this.baseURL}/articles/recommendation`,
        {
          params:{
            'pageNum':pageNum,
            'pageSize':pageSize
          },
          headers:{
            'Authorization':Config.auth,
            'Content-Type':'application/json'
          }
        }
      )
        .then(resp => {
          if(resp.status === 200) {
            //查询成功
            console.log('获取文章数据成功：',JSON.stringify(resp.data))
            resolve(resp.data)
          } else {
            console.error('获取文章数据失败：',JSON.stringify(resp))
            reject('获取文章数据失败')
          }
        })
        .catch(error => {
          console.error('获取文章数据失败：',JSON.stringify(error))
          reject('获取文章数据失败')
        })
    })
  }

  getArticles(pageNum:number,pageSize:number):Promise<ResponseModel<JSONObject>> {
    let requestUrl:string = `${Config.baseUrl}/articles`
    console.info('info, requestUrl: '+requestUrl)

    return new Promise((resolve,reject) => {
      axios.get(
        requestUrl,
        {
          headers:{
            'Authorization':Config.auth
          },
          params:{
            pageNum:pageNum,
            pageSize:pageSize
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

  postArticle(article:Article):Promise<ResponseModel<null>> {
    let requestUrl:string = `${Config.baseUrl}/articles`
    console.info('info, requestUrl: '+requestUrl)

    return new Promise((resolve,reject) => {
      axios.post(
        requestUrl,
        {
          title:article.title,
          content:article.content,
          coverImg:article.coverImg,
          bookId:article.bookId
        },
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

  getArticleById(id:number):Promise<ResponseModel<Article>> {
    let requestUrl:string = `${Config.baseUrl}/articles/${id}`
    console.info('info, requestUrl: '+requestUrl)

    return new Promise(async (resolve,reject) => {
      await axios.get(
        requestUrl,
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

const articleRequestUtil = new ArticleRequestUtil()

export  default articleRequestUtil as ArticleRequestUtil