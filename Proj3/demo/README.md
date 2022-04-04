# To start app run
>`./gradlew bootRun`
# To test auth  <br>
>`curl -s -X POST  -H "Content-Type: application/json"   http://172.17.0.2:8080/login -d '{"username": "root", "password":"root1"}'` <br>
\> Auth error! <br>

>`curl -s -X POST  -H "Content-Type: application/json"   http://172.17.0.2:8080/login -d '{"username": "root", "password":"root"}'` <br>
\> Success! <br>