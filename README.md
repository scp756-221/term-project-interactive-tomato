[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-f059dc9a6f8d3a56e377f745f24479a46679e63a5d9fe6f495e02850cd0d8118.svg)](https://classroom.github.com/online_ide?assignment_repo_id=7031605&assignment_repo_type=AssignmentRepo)

# CMPT 756 Term Project - Team Interactive Tomato

## File Structure
- `artist/`: project files of the artist service
- `ci/`: includes a `docker-compose` configuration file for deploying multiple microservices and running the test cases under `test/` as a container; can be used on a local machine or used as a part of the CI pipeline
- `db/`: project files of the db service
- `music/`: project files of the music service
- `test/`: files for testing the function of microservices, including unit testing and integration testing
- `user/`: project files of the user service

## Third-Party Services
### Amazon DynamoDB
Used as the primary datastore for this application.
Three tables (`User-<team>`, `Music-<team>`, and `Artist-<team>`) are created for each of the microservices involved, where `<team>` stands for `interactive-tomato`.
A [local version](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html) is available for development and testing purposes, which we are using as a Docker container.

### Grafana
A tool for creating and running dashboards: arrangements of statistics, tables, and plots that summarize the current state of a distributed system

### Prometheus
TODO

### More
TODO

## Microservices
These microservices implement the functionalities of our application using Flask.
Each of these services exposes some number of REST APIs for inter-service data exchange as well as the basis of user interaction.

### DB Service
A wrapper of DynamoDB as REST APIs, other microservices call these APIs to interact with the database in an easier and more consistent manner.

### User Service
This service provides common functionalities of managing user accounts.

### Music Service
This is a service used for adding and updating metadata of songs while also offering search capabilities.

### Artist Service
This service works as an example of introducing a new service to the existing application, enabling maintainers to manage artist/band information.

## Local/CI Deployment and Testing Using Docker
Each of the microservice has been containerized (see `Dockerfile` under each folder).
To deploy and run these services using Docker, use the file `docker-compose.yml` in `ci/` and run:

```shell
cd ci/
docker-compose up --build
```

You can remove `--build` to avoid rebuilding images if none of the images are updated.

Aside from deploying microservices and other third-party applications, this `docker-compose.yml` configuration file also runs a container for testing (in `test/`), powered by pytest.
When the testing container is run, tables will be created for the local DynamoDB instance so that other microservices can query or update the database normally.

## Working with Clusters
TODO
