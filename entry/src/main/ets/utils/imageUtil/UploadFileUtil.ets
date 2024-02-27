import common from '@ohos.app.ability.common';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import bundleManager from '@ohos.bundle.bundleManager';
import picker from '@ohos.file.picker';
import Config from '../../common/types/Config';
import request from '@ohos.request';
import fs from '@ohos.file.fs'
class UploadFileUtil {

  async requestMediaPermission() {
    let context = getContext(this) as common.UIAbilityContext;
    let atManager = abilityAccessCtrl.createAtManager();
    let info = await bundleManager.getBundleInfoForSelf(0);
    if (info && info.appInfo) {
      let result = atManager.verifyAccessTokenSync(info.appInfo.accessTokenId, "ohos.permission.READ_MEDIA");
      if (abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED == result) {
        console.log("has permission")
      }
    } else {
      atManager.requestPermissionsFromUser(context, ["ohos.permission.READ_MEDIA"], (error, result) => {
        if (result) {
          console.log("result: " + JSON.stringify(result));
          if (result.authResults[0] == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
            // 用户授予权限
            // this.mediaMessage = "用户已经授权";
            this.openGallery();
          } else {
            // 用户拒绝权限
            // this.mediaMessage = "用户拒绝授权";
            console.log("permission denied")
          }
        } else {
          // this.mediaMessage = "请求授权异常：" + JSON.stringify(error);
          console.log("error: " + JSON.stringify(error));
        }
      });
    }
  }

  // 创建PhotoViewPicker实例，打开相册，调用select()方法
  openGallery() {
    let photoPicker = new picker.PhotoViewPicker();
    photoPicker.select({
      MIMEType: picker.PhotoViewMIMETypes.IMAGE_TYPE, // 只选择图片
      maxSelectNumber: 1 // 选择图片数量
    }, (error, result) => {
      if (result) {
        result.photoUris.forEach((url) => {
          // this.uploadFile(url);
          console.log("url地址: " + url+'photoUris'+result.photoUris);
        })
        this.uploadImages(result.photoUris)
      }
      // console.log("url地址: " + JSON.stringify(error));
    })
  }

  uploadImages(paths: string[]) {
    var allFiles = Array<request.File>()
    for (var i = 0; i <paths.length; i++) {
      var path = this.copyImg(paths[i])
      console.log("path: " + path)
      let realUri = "internal://cache/"+path.split("cache/")[1];
      allFiles[i] = {
        name: "image" + i + ".jpg",
        filename: "image" + i + ".jpg",
        uri: realUri,
        type: "image"
      }
    }
    let uploadTask;
    let uploadConfig = {
      url: `${Config.baseUrl}/upload`, //需要手动替换为真实服务器地址
      header: { 'Accept': '*/*' ,'Authorization':Config.auth},
      method: "POST",
      files: allFiles,
      data: [{ name: "name123", value: "123" }],
    };
    try {
      request.uploadFile( getContext(this), uploadConfig).then((data) => {
        uploadTask = data;
        console.log('applog2');
        let upProgressCallback = (uploadedSize, totalSize) => {
          console.info("applog:upload totalSize:" + totalSize + "  uploadedSize:" + uploadedSize);
        };
        uploadTask.on('progress', upProgressCallback);
      }).catch((err) => {
        console.error('Failed to request the upload. Cause: ' + JSON.stringify(err));
      });
    } catch (err) {
      console.error('applog:'+JSON.stringify(err));
      console.error('err.code : ' + err.code + ', err.message : ' + err.message);
    }


    // try {
    //   let context = getContext(this) as common.UIAbilityContext;
    //   request.uploadFile(/*globalThis.abilityContext*/context, uploadConfig).then((data) => {
    //     uploadTask = data;
    //     console.log('uploadTask:'+JSON.stringify(uploadTask))
    //   }).catch((err) => {
    //     console.error('Failed to request the upload. Cause: ' + JSON.stringify(err));
    //   });
    // } catch (err) {
    //   console.error('err.code : ' + err.code + ', err.message : ' + err.message);
    // }
  }

  // uploadFile(url:string) {
  //   let uploadTask;
  //   let uploadConfig = {
  //     url: `${Config.baseUrl}/upload`, //需要手动替换为真实服务器地址
  //     header: { 'Accept': '*/*' ,'Authorization':Config.auth},
  //     method: "POST",
  //     files: [{ filename: "test", name: "test", uri: "internal://cache/test.jpg", type: "jpg" }],
  //     data: [{ name: "name123", value: "123" }],
  //   };
  //   try {
  //     request.uploadFile(globalThis.abilityContext, uploadConfig).then((data) => {
  //       uploadTask = data;
  //     }).catch((err) => {
  //       console.error('Failed to request the upload. Cause: ' + JSON.stringify(err));
  //     });
  //   } catch (err) {
  //     console.error('err.code : ' + err.code + ', err.message : ' + err.message);
  //   }
  // }

  private copyImg(imgUrl:string):string {
    console.log('fileUri:'+imgUrl);
    let context = getContext(this) as common.UIAbilityContext;
    let newPath = context.cacheDir + "/image.jpg";

    fs.open(imgUrl, fs.OpenMode.READ_WRITE).then((file) => {
      console.info("file fd: " + file.fd);
      fs.copyFile(file.fd, newPath).then(() => {
        console.info("copy file succeed");
        //return newPath
      }).catch((err) => {
        console.info("copy file failed with error message: " + err.message + ", error code: " + err.code);
      });

    }).catch((err) => {
      console.info("open file failed with error message: " + err.message + ", error code: " + err.code);
    })

    return newPath
  }
}

const uploadFileUtil = new UploadFileUtil()

export  default uploadFileUtil as UploadFileUtil