# raml-js-webservice-generator

RAML webservice generator .. is still in development!!

##RAML Example

```YAML

   #%RAML 0.8
    
   title: World Music API
   baseUri: http://example.api.com/{version}
   version: v1
   traits:
     - paged:
         queryParameters:
           pages:
             description: The number of pages to return
             type: number
   schemas:
    - actor: !include ../../../test/fixtures/movies/actor.schema
    - genre: !include ../../../test/fixtures/movies/genre.schema
    - movie: !include ../../../test/fixtures/movies/movie.schema
    - news: !include ../../../test/fixtures/movies/news.schema
    - autor: !include ../../../test/fixtures/movies/autor.schema
   /movie:
     get:
       responses:
         200:
           body:
             application/json:
               schema: "Movie[]"
     post:
       responses:
         200:
           body:
             application/json:
               schema: "Movie"
     /top:
       get:
         responses:
           200:
             body:
               application/json:
                 schema: "Movie[]"
     /{id}:
       get:
         responses:
           200:
             body:
               application/json:
                 schema: "Movie"
       put:
         responses:
           200:
             body:
               application/json:
                 schema: "Movie"
       delete:
         responses:
           200:
             body:
               application/json:
                 schema: "Movie"
       /genres:
         get:
           responses:
             200:
               body:
                 application/json:
                   schema: "Genre[]"
   /news:
     get:
       responses:
         200:
           body:
             application/json:
               schema: "News[]"
     post:
       responses:
         200:
           body:
             application/json:
               schema: "News"
     /latest:
       get:
         responses:
           200:
             body:
               application/json:
                 schema: "News[]"
     /{id}:
       get:
         responses:
           200:
             body:
               application/json:
                 schema: "News"
       put:
         responses:
           200:
             body:
               application/json:
                 schema: "News"
       delete:
         responses:
           200:
             body:
               application/json:
                 schema: "News"
   /autor:
     get:
       responses:
         200:
           body:
             application/json:
               schema: "Autor[]"
     post:
       responses:
         200:
           body:
             application/json:
               schema: "Autor"
     /featured:
       get:
         responses:
           200:
             body:
               application/json:
                 schema: "Autor[]"
     /{id}:
       get:
         responses:
           200:
             body:
               application/json:
                 schema: "Autor"
       put:
         responses:
           200:
             body:
               application/json:
                 schema: "Autor"
       delete:
         responses:
           200:
             body:
               application/json:
                 schema: "Autor"
   /actor:
     get:
       responses:
         200:
           body:
             application/json:
               schema: "Actor[]"
     post:
       responses:
         200:
           body:
             application/json:
               schema: "Actor"
     /featured:
       get:
         responses:
           200:
             body:
               application/json:
                 schema: "Actor[]"
     /{id}:
       get:
         responses:
           200:
             body:
               application/json:
                 schema: "Actor"
       put:
         responses:
           200:
             body:
               application/json:
                 schema: "Actor"
       delete:
         responses:
           200:
             body:
               application/json:
                 schema: "Actor"
   /genre:
     get:
       responses:
         200:
           body:
             application/json:
               schema: "Genre[]"
     post:
       responses:
         200:
           body:
             application/json:
               schema: "Genre"
     /featured:
       get:
         responses:
           200:
             body:
               application/json:
                 schema: "Genre[]"
     /{id}:
       get:
         responses:
           200:
             body:
               application/json:
                 schema: "Genre"
       put:
         responses:
           200:
             body:
               application/json:
                 schema: "Genre"
       delete:
         responses:
           200:
             body:
               application/json:
                 schema: "Genre"
```
##Output Schema
![consola](https://github.com/jahd2602/raml-js-webservice-generator/raw/master/doc/images/schema.png "Schema Generado")