Project was developed on docker container provided by fluent.
### How to start project?
To start run: <br>
Create empty database file:
```
vapor run migrate
```
Start project: <br>
```
swift run
```
### The database relation
The model Star has parent Galaxy. <br>
Creation of Star with some Galaxy name result in creation of that Galaxy if not already exists. <br>
Edit of Star Galaxy will result in Galaxy db being updated. <br>