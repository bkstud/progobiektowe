package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/labstack/echo/v4"
)

var URL = "http://webcode.me"

type GetProxy struct {
	baseUrl string
}

func (gp *GetProxy) Get(endpoint string) (int, string, error) {
	var url = gp.baseUrl + "/" + endpoint
	resp, err := http.Get(url)
	if err != nil {
		return 0, "", err
	}

	defer resp.Body.Close()

	body, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		log.Fatal(err)
		return 0, "", err
	}

	return resp.StatusCode, string(body), nil
}

func main() {
	e := echo.New()
	gp := GetProxy{URL}

	e.GET("/*", func(ctx echo.Context) error {
		var endpoint string = ctx.ParamValues()[0]

		fmt.Println("Forwarding GET endpoint to proxy:", endpoint)

		status, sb, err := gp.Get(endpoint)

		if err != nil {
			panic(fmt.Errorf("Get proxy failed with error %v", err))
		}

		return ctx.String(status, sb)
	})

	e.Logger.Fatal(e.Start(":1323"))
}
