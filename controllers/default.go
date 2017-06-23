package controllers

import (
	"github.com/astaxie/beego"
	"encoding/json"
	"github.com/astaxie/beego/httplib"
	"crypto/tls"
	"github.com/astaxie/beego/logs"
)

type MainController struct {
	beego.Controller
}

func (c *MainController) Get() {
	c.TplName = "index.tpl"
}


func (c *MainController) GetCardInfo()  {
	var result map[string]string
	json.Unmarshal(c.Ctx.Input.RequestBody,&result)
	base64 , ok:= result["base64"]
	//logs.Debug(base64)
	if !ok || len(base64) < 1 {
		c.Ctx.WriteString("{'message': '图片不能为空'}")
		return
	}

	cardInfo, err := httplib.Post(beego.AppConfig.String("face_url")).
		SetTLSClientConfig(&tls.Config{InsecureSkipVerify:true}).
		Param("api_key", beego.AppConfig.String("face_api_key")).
		Param("api_secret", beego.AppConfig.String("face_api_secret")).
		Param("image_base64", base64).String()
	logs.Debug(cardInfo)
	if err == nil {
		c.Ctx.WriteString(cardInfo)
		return
	}
	c.Ctx.WriteString("{'message': '未知错误'}")
}