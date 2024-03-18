# SpringSeedGenerator
The Spring Boot Project Shell Script automates Spring Boot project setup, generating entities, repositories, DTOs, and adding dependencies to pom.xml. Efficiently kickstart your Spring Boot projects!

## Usage

1. Clone or download this repository to your local machine.
2. Open a terminal and navigate to the directory containing the script.
3. Ensure the script has executable permissions. If not, run `chmod +x springboot.sh` to add execute permissions.
4. Run the script using `./springboot.sh`.

### Commands

- `./springboot.sh new <project_name>`: Create a new Spring Boot project.
- `./springboot.sh make:model <entity_name>`: Generate entity classes, repository interfaces, DTOs, and mappers for a specified entity.

## Project Structure

- `springboot.sh`: Main shell script file.
- `Entity/`: Directory to store generated entity classes.
- `EntityRepository/`: Directory to store generated repository interfaces.
- `DtoEntity/`: Directory to store generated DTO classes.
- `Mapper/`: Directory to store generated mapper classes.

## License

This project is licensed under the MIT License.