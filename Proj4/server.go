package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/labstack/echo/v4"
)

var URL = "http://webcode.me"

func main() {
	e := echo.New()
	e.GET("/*", func(ctx echo.Context) error {
		var endpoint string = ctx.ParamValues()[0]
		var url = URL + "/" + endpoint
		fmt.Println("Forwarding GET to URL: ", url)
		resp, err := http.Get(url)
		if err != nil {
			return err
		}

		defer resp.Body.Close()

		body, err := ioutil.ReadAll(resp.Body)

		if err != nil {
			log.Fatal(err)
			return err
		}

		return ctx.String(resp.StatusCode, string(body))
	})

	e.Logger.Fatal(e.Start(":1323"))
}
