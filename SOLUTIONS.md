Hola,

paso a explicar las soluciones:
1. Challenge1
Modifiqué el archivo data/mongoflask.py añadiendo find_one de la forma:
def find_restaurants(mongo, _id=None):
    query = {}
    if _id:
        query["_id"] = ObjectId(_id)
        return mongo.db.restaurant.find_one(query)
    return list(mongo.db.restaurant.find(query))

Esto lo hice para devolver un objeto en vez de una lista cuando se incluía un ID en la petición
Para devolver un 204 cuando no se encuentra el ID, modifiqué el archivo app.py añadiendo el if-else en:
def restaurant(id):
    restaurants = find_restaurants(mongo, id)
    if restaurants:
        return jsonify(restaurants)
    else:
        return '',204


2. Challenge2
Como la herramienta que más conozco es Jenkins, añado un pipeline en el codigo. Es el archivo Jenkinsfile. Creo que tiene poca explicación

3. Challenge3
Incluyo el archivo Dockerfile_app y un Dockerfile_app.dockerignore para intentar reducir al máximo el tamaño del container. La única cosa extraña que tiene es que incluyo un parametro de compilación para poder pasar la URL de la BBDD de Mongo en tiempo de compilación

4. Challenge4
Al igual que en el punto anterior, incluyo Dockerfile_mongo y Dockerfile_mongo.dockerignore para intentar reducir el tamaño del container. Aqui copio un archivo js para crear el usuario de la BBDD, copio el archivo restaurant y despues con mongoimport importo dicho archivo restaurant.

5. Challenge5
Apoyandome en los containers anteriormente creados, creo el archivo docker-compose.yml donde configuro las imágenes de los containers y el volumen de la BBDD para conseguir la persistencia de los datos

6. Challenge6
El archivo kubedeploy.yml tiene la configuración para Kubernetes. Tengo 2 deployments y 2 services. Está hecho asi para mantener la posibilidad de escalar alguno de los 2 nodos y mantener la independencia de los mismos. Podía haber creado un unico pod con ambos contenedores en su interior pero creo que esto ofrece más posibilidades. Ambos deployments y services se despliegan en el namespace devops-challenge, tienen reserva de CPU y RAM y livenessprobe. En el caso de la app se comprueba que la peticion de restaurantes devuelva un 200 y en el de mongo se hace uso del comando db.adminCommand() para chequear que el sistema está operativo. Además en el caso de mongo se mapea un volumen para mantener la persistencia de los datos.

Después se despliegan los servicios: de tipo LoadBalancer para la app, y de tipo ClusterIP para mongo ya que solo necesitará que se conecte el servicio de la app.
