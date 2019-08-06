# Reading Time
Reading Time is a web application that lists staff recommended books.

## Installing

### Prerequisites
Reading Time requires Java and [Maven](https://maven.apache.org/). It uses an embedded Tomcat servlet container. To test if you have Java and Maven installed open a terminal and type:
```
mvn --version
```

### Running

To run the application:
```
mvn clean install
sh target/bin/webapp
open http://localhost:8080
```

To install without running the tests:
```
mvn -B -DskipTests=true clean install
```
To run the unit tests:
```
mvn clean test
```
To run code coverage checks:
```
mvn cobertura:check
```
To create the code coverage report:
```
mvn cobertura:cobertura
open target/site/cobertura/index.html
```
To create and view the Maven reports:
```
mvn site
open target/site/index.html
```

## Setting up Actions

### Specify which Azure Web App to deploy

This wofkflow builds war file and deploys it to Azure Web Apps. To deploy your own Azure Web Apps, edit the following lines under azure-webapp-maven-plugin in `pom.xml`:

```xml
                    <subscriptionId>7c458c93-920c-4ed1-b26d-5b4ab57c0711</subscriptionId>
                    <resourceGroup>reading-times</resourceGroup>
                    <appName>reading-time-app</appName>
```

To confirm your `subscriptionId` from the following command:

```shell
$ az account list
```

### Authentication

To authenticate Azure, you should [create the password-based service principal](https://docs.microsoft.com/ja-jp/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest#password-based-authentication).

And then, specify the following secrets to your repository settings.

| AZ_USER_NAME | User name of the service principal |
| AZ_PASSWORD | Password of the service principal |
| AZ_TENANT_ID | Tenant ID of the service principal |

## Contributing
Read the [CONTRIBUTING](.github/CONTRIBUTING.md) file before contributing to this project.

## License
See the [LICENSE](LICENSE.md) file for license rights and limitations (MIT).
