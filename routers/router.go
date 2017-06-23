package routers

import (
	"camera-test/controllers"
	"github.com/astaxie/beego"
)

func init() {
    beego.Router("/", &controllers.MainController{})
	beego.Router("/cardInfo", &controllers.MainController{}, "*:GetCardInfo")
}
