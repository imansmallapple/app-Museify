import preferences from '@ohos.data.preferences';
import common from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';
import { BusinessError } from '@ohos.base';


class Storage {
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  readonly TOKEN_KEY = "tokenKey"

  constructor() {
  }

  // Preference General Functionalities

  private async getPreferences() {
    let options: preferences.Options = {
      name: 'myStore'
    }
    let dataPreferences = preferences.getPreferencesSync(this.context, options) as preferences.Preferences
    return dataPreferences
  }

  private async checkPreference(key: string) {
    if ((await this.getPreferences()).hasSync(key)) {
      hilog.info(0x00, 'checkPreferenceResult', `The key ${key} is contained.`)
      return true
    } else {
      hilog.info(0x00, 'checkPreferenceResult', `The key ${key} does not contain.`)
      return false
    }
  }

  public async getValue(key: string) {
    if (await this.checkPreference(key)) {
      let value = (await this.getPreferences()).getSync(key, 'default')
      hilog.info(0x00, 'checkPreferenceResult', `The key ${key} value is ` + value);

      // todo: Need Implement 当获取的值为带有特殊字符的字符串时，需要将获取到的Uint8Array转换为字符串
      // let uInt8Array2: preferences.ValueType = dataPreferences.getSync('uInt8', new Uint8Array(0));
      // let textDecoder = util.TextDecoder.create('utf-8');
      // val = textDecoder.decodeWithStream(uInt8Array2 as Uint8Array);
      // hilog.info(0x00, 'contextTest7', "The 'uInt8' value is " + val);

      return value as string
    } else {
      hilog.info(0x00, 'checkPreferenceResult', `The key ${key} does not contain.`)
      return null
    }
  }

  public async putValue(key: string, value: string) {
    //Put data
    (await this.getPreferences()).put(key, value, (err: BusinessError) => {
      if (err) {
        hilog.error(0x00, 'checkValueResult', `Failed to put value of ${key}. code =` + err.code + ", message =" + err.message)
        return
      }
      hilog.info(0x00, 'checkValueResult', `Succeeded in putting value of ${key}.`)
      this.flushAllData()
    })
  }

  public async getAllPair() {
    //getAll
    (await this.getPreferences()).getAll((err: BusinessError, value: Object) => {
      if (err) {
        console.error("Failed to get all key-values. code =" + err.code + ", message =" + err.message)
        return
      }
      let allKeys = this.getObjKeys(value)
      console.info("getAll keys = " + allKeys)
      console.info("getAll object = " + JSON.stringify(value))
    })
  }

  private async flushAllData() {
    (await this.getPreferences()).flush((err: BusinessError) => {
      if (err) {
        hilog.error(0x00, 'checkFlushResult', "Failed to flush. code =" + err.code + ", message =" + err.message);
        return;
      }
      hilog.info(0x00, 'checkFlushResult', "Succeeded in flushing.");
    })
  }

  private getObjKeys(obj: Object): string[] {
    let keys = Object.keys(obj)
    return keys
  }

  // Token Management

  public async saveToken(token: string) {
    hilog.info(0x00, 'saveTokenResult', "start saveToken")
    let preferences = await this.getPreferences()
    let result = await preferences.put(this.TOKEN_KEY, token);
    // 将当前Preferences实例的数据异步存储到首选项持久化文件中
    preferences.flush((err) => {
      if (err) {
        hilog.error(0x00, 'saveTokenResult', 'saveToken flush fail')
        return
      }
      hilog.info(0x00, 'saveTokenResult', 'saveToken flush success')
    })
    return result
  }

  public async clearToken(){
    let preferences = await this.getPreferences()
    let result = preferences.put(this.TOKEN_KEY, "")
    preferences.flush((err)=>{
      if (err) {
        hilog.info(0x00, 'clearTokenResult', "clearToken flush fail")
        return
      }
      hilog.info(0x00, 'clearTokenResult', "saveToken flush success")
    })
    return result;
  }

  public async getToken(){
    let preferences = await this.getPreferences()
    let token = await preferences.get(this.TOKEN_KEY,"");
    return token;
  }
  
}

export default Storage