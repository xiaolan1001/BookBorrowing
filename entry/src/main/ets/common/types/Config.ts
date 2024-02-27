class Config {
  baseUrl:string = 'http://60.204.248.186:8080'
  aliOSS:string = 'https://book-borrowing.oss-cn-shenzhen.aliyuncs.com/'
  auth:string
}

const config = new Config()

export default config as Config