import picker from '@ohos.file.picker';
import request from '@ohos.request';
import http from '@ohos.net.http';
import Config from '../../common/types/Config';
import fs from '@ohos.file.fs'
import ResponseModel from '../../model/ResponseModel';
import axios from '@ohos/axios';

/**
 * 文件选择
 * @returns
 */
export async function fileSelect(): Promise<string> {
  let photoSelectOptions = new picker.PhotoSelectOptions();
  photoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
  photoSelectOptions.maxSelectNumber = 1;
  let photoPicker = new picker.PhotoViewPicker();
  try {
    let photoSelectResult = await photoPicker.select(photoSelectOptions);
    if (photoSelectResult && photoSelectResult.photoUris && photoSelectResult.photoUris.length > 0) {
      let imgUri = photoSelectResult.photoUris[0];
      if (imgUri.indexOf('media/image') < 0) {
        return '';
      }
      return imgUri;
    } else {
      return '';
    }
  } catch (err) {
    console.error('SelectedImage failed', JSON.stringify(err));
    return '';
  }
}
export function upload(context:Context,fileUri:string,callback:(data: string) => void,error?:(msg:string) => void):Promise<string> {
  let cacheDir = context.cacheDir;
  let imgName = fileUri.split('/').pop() + '.jpg';
  let dstPath = cacheDir + '/' + imgName;
  let requestUrl = Config.baseUrl + '/upload';
  let fid=""+new Date().getTime()+Math.floor(1000 + Math.random() * 9000);

  let uploadRequestOptions: request.UploadConfig = {
    url: requestUrl,
    header: {
      'Content-Type': 'multipart/form-data',
      'Authorization': Config.auth
    },
    method: http.RequestMethod.POST, //缺省为POST请求
    //files:Array<File>, 要上传的文件列表。请使用multipart/form-data提交。
    files: [{
      filename: imgName,
      name: 'file',
      uri: 'internal://cache/' + imgName, //仅支持“internal”协议类型，“internal://cache/”为必填字段
      type: 'jpg'
    }],
    //data:Array<RequestData>请求的表单数据
    data: [{
      name: "fid",
      value: fid
    }]
  }
  console.debug('请求地址：'+requestUrl)
  return new Promise((resolve:Function,reject:Function) => {
    try {
      // 1.Copy the URI to the cacheDir directory and upload the file.
      let srcFile = fs.openSync(fileUri);
      let dstFile = fs.openSync(dstPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.copyFileSync(srcFile.fd, dstFile.fd);
      fs.closeSync(srcFile);
      fs.closeSync(dstFile);

      // 2.Upload the file.
      request.uploadFile(context, uploadRequestOptions)
        .then((data:request.UploadTask) => {
          data.on('complete', (result: Array<request.TaskState>) => {
            console.info('上传图片成功', JSON.stringify(result))
            resolve(fid)
          })

          data.on('fail', (result: Array<request.TaskState>) => {
            console.info('上传图片失败', JSON.stringify(result));
            error('上传失败')
          })
        })
        .catch((err: Error) => {
          console.error('上传图片失败', JSON.stringify(err));
          error('上传失败')
        });
    } catch (err) {
      console.error('上传图片失败', JSON.stringify(err));
      error('上传失败')
    }
  })
}

export async function updateImageUrl(url:string):Promise<ResponseModel<null>> {
  let requestUrl:string = `${Config.baseUrl}/user/avatar`
  console.info('info, requestUrl: '+requestUrl)

  return new Promise(async (resolve,reject) => {
    await axios.put(
      requestUrl,
      null,
      {
        headers:{
          'Authorization':Config.auth,
          'Content-Type':'application/json'
        },
        params:{
          avatarUrl:url
        }
      }
    )
      .then(resp => {
        if(resp.data === 200) {
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