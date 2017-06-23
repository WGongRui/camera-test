package main

import (
	_ "camera-test/routers"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
)

func main() {
	logs.Async()
	logs.SetLogger(logs.AdapterFile, `{"filename":"camera-test.log"}`)
	beego.Run()
}

