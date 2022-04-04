# To start app run
`./gradlew bootRun`
# To test auth 
`curl -s -X POST  -H "Content-Type: application/json"   http://172.17.0.2:8080/login -d '{"username": "root", "password":"root1"}'`
> Auth error!
`curl -s -X POST  -H "Content-Type: application/json"   http://172.17.0.2:8080/login -d '{"username": "root", "password":"root"}'`
> Success!