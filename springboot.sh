#!/bin/bash

CURRENT_DIR=$(pwd)
PROJECT_NAME="project"
ARCHITECTURE="maven"
GRADLE_TYPE="gradle-project"
DEPENDENCIES=("web")

generate_entity()
{
    local entity="$1"
    shift
    local ENTITY=("$@")
    
    #lets do the header of page , the imports etc ..
    echo "package com.example.$PROJECT_NAME.Entity;" > "Entity/${entity}.java"
    echo "import jakarta.persistence.Column;" >> "Entity/${entity}.java"
    echo "import jakarta.persistence.Entity;" >> "Entity/${entity}.java"
    echo "import jakarta.persistence.GeneratedValue;" >> "Entity/${entity}.java"
    echo "import jakarta.persistence.GenerationType;" >> "Entity/${entity}.java"
    echo "import jakarta.persistence.Id;" >> "Entity/${entity}.java"
    echo "import jakarta.persistence.Table;" >> "Entity/${entity}.java"
    echo "import java.util.Date;" >> "Entity/${entity}.java"
    echo "import lombok.AllArgsConstructor;" >> "Entity/${entity}.java"
    echo "import lombok.Getter;" >> "Entity/${entity}.java"
    echo "import lombok.Setter;" >> "Entity/${entity}.java"
    echo "import lombok.NoArgsConstructor;" >> "Entity/${entity}.java"
    echo "" >> "Entity/${entity}.java"
    echo "@Getter" >> "Entity/${entity}.java"
    echo "@Setter" >> "Entity/${entity}.java"
    echo "@NoArgsConstructor" >> "Entity/${entity}.java"
    echo "@AllArgsConstructor" >> "Entity/${entity}.java"
    echo "@Entity" >> "Entity/${entity}.java"
    echo "@Table(name=\"${entity}s\")" >> "Entity/${entity}.java"
    echo "public class ${entity} {" >> "Entity/${entity}.java"
    
    echo "" >> "Entity/${entity}.java"
    echo "    @Id" >> "Entity/${entity}.java"
    echo "    @GeneratedValue(strategy = GenerationType.IDENTITY)" >> "Entity/${entity}.java"
    echo "    private Long id;" >> "Entity/${entity}.java"
    
    for((i=0 ; i <${#ENTITY[@]}; i+=3));do
        field_name="${ENTITY[$i]}"
        field_type="${ENTITY[$i+1]}"
        is_nullable="${ENTITY[$i+2]}"
        
        echo "" >> "Entity/${entity}.java"
        echo "    @Column(name=\"${field_name}\" , nullable = ${is_nullable})" >> "Entity/${entity}.java"
        echo "    private ${field_type} ${field_name};" >> "Entity/${entity}.java"
    done
    echo "" >> "Entity/${entity}.java"
    echo "}" >> "Entity/${entity}.java"

}

generate_entity_repository()
{
    local entityrepository="$1"
    local entity="$2"
    echo "package com.example.$PROJECT_NAME.EntityRepository;" > "EntityRepository/${entityrepository}.java"
    echo "import org.springframework.data.jpa.repository.JpaRepository;" >> "EntityRepository/${entityrepository}.java"
    echo "import com.example.$PROJECT_NAME.Entity.$entity;" >> "EntityRepository/${entityrepository}.java"
    echo "" >> "EntityRepository/${entityrepository}.java"
    echo "public interface $entityrepository extends JpaRepository<${entity}, Long> " >> "EntityRepository/${entityrepository}.java"
    echo "{" >> "EntityRepository/${entityrepository}.java"
    echo "" >> "EntityRepository/${entityrepository}.java"
    echo "}" >> "EntityRepository/${entityrepository}.java"
}

generate_entity_dto()
{
    local entity="$1"
    shift
    local ENTITY=("$@")
    echo "package com.example.$PROJECT_NAME.DtoEntity;" > "DtoEntity/${entity}Dto.java"
    echo "import lombok.AllArgsConstructor;" >> "DtoEntity/${entity}Dto.java"
    echo "import lombok.Getter;" >> "DtoEntity/${entity}Dto.java"
    echo "import lombok.Setter;" >> "DtoEntity/${entity}Dto.java"
    echo "import lombok.NoArgsConstructor;" >> "DtoEntity/${entity}Dto.java"
    echo "import java.util.Date;" >> "DtoEntity/${entity}Dto.java"
    echo "" >> "DtoEntity/${entity}Dto.java"
    echo "@Getter" >> "DtoEntity/${entity}Dto.java"
    echo "@Setter" >> "DtoEntity/${entity}Dto.java"
    echo "@NoArgsConstructor" >> "DtoEntity/${entity}Dto.java"
    echo "@AllArgsConstructor" >> "DtoEntity/${entity}Dto.java"
    echo "" >> "DtoEntity/${entity}Dto.java"
    echo "public class ${entity}Dto " >> "DtoEntity/${entity}Dto.java"
    echo "{" >> "DtoEntity/${entity}Dto.java"
    echo "    private Long id;" >> "DtoEntity/${entity}Dto.java"

    for((i=0 ; i <${#ENTITY[@]}; i+=3));do
        field_name="${ENTITY[$i]}"
        field_type="${ENTITY[$i+1]}"
        is_nullable="${ENTITY[$i+2]}"
        
        echo "" >> "DtoEntity/${entity}Dto.java"
        echo "    private ${field_type} ${field_name};" >> "DtoEntity/${entity}Dto.java"
    done
    echo "" >> "DtoEntity/${entity}Dto.java"
    echo "}" >> "DtoEntity/${entity}Dto.java"
}

generate_mapper()
{
    local entity="$1"
    shift
    local ENTITY=("$@")

    local entityvar="${entity,}"

    echo "package com.example.$PROJECT_NAME.Mapper;" > "Mapper/${entity}Mapper.java"
    echo "import com.example.$PROJECT_NAME.Entity.${entity};" >> "Mapper/${entity}Mapper.java"
    echo "import com.example.$PROJECT_NAME.DtoEntity.${entity}Dto;" >> "Mapper/${entity}Mapper.java"
    echo "" >> "Mapper/${entity}Mapper.java"
    echo "public class ${entity}Mapper {" >> "Mapper/${entity}Mapper.java"
    
    # maptoDto method :
    echo "    public static ${entity}Dto mapTo${entity}Dto(${entity} ${entityvar})" >> "Mapper/${entity}Mapper.java"
    echo "    {">> "Mapper/${entity}Mapper.java"
    echo "        return new ${entity}Dto" >> "Mapper/${entity}Mapper.java"
    echo "        (" >> "Mapper/${entity}Mapper.java"
    echo "            ${entityvar}.getId()" >> "Mapper/${entity}Mapper.java"
    echo "" >> "Mapper/${entity}Mapper.java"
    local first=true
    for((i=0 ; i <${#ENTITY[@]}; i+=3));do
        field_name="${ENTITY[$i]}"
        field_name_with_first_upper="${field_name^}"
        echo "" >> "Mapper/${entity}Mapper.java"
        first=true

        if [ "$first" = true ]; then
            echo -n ",            ${entityvar}.get${field_name_with_first_upper}()" >> "Mapper/${entity}Mapper.java"
            echo "" >> "Mapper/${entity}Mapper.java"
            first=false
        else
            echo -n "            ${entityvar}.get${field_name_with_first_upper}()" >> "Mapper/${entity}Mapper.java"
        fi
        
    done
    echo "        );" >> "Mapper/${entity}Mapper.java"
    echo "    }" >> "Mapper/${entity}Mapper.java"
    # maptoEntity method : 
    echo "    public static ${entity} mapTo${entity}(${entity}Dto ${entityvar}Dto) {" >> "Mapper/${entity}Mapper.java"
    echo "        return new ${entity}" >> "Mapper/${entity}Mapper.java"
     echo "        (" >> "Mapper/${entity}Mapper.java"
    echo "            ${entityvar}Dto.getId()" >> "Mapper/${entity}Mapper.java"
    first=true
    echo "" >> "Mapper/${entity}Mapper.java"
    for((i=0 ; i <${#ENTITY[@]}; i+=3));do
        field_name="${ENTITY[$i]}"
        field_name_with_first_upper="${field_name^}"
        echo "" >> "Mapper/${entity}Mapper.java"
        first=true
        if [ "$first" = true ]; then
            echo -n ",            ${entityvar}Dto.get${field_name_with_first_upper}()" >> "Mapper/${entity}Mapper.java"
            echo "" >> "Mapper/${entity}Mapper.java"
            first=false
        else
            echo -n "            ${entityvar}Dto.get${field_name_with_first_upper}()" >> "Mapper/${entity}Mapper.java"
        fi

    done
    echo "        );" >> "Mapper/${entity}Mapper.java"
    echo "    }" >> "Mapper/${entity}Mapper.java"


    echo "}" >> "Mapper/${entity}Mapper.java"
}

generate_Iservice()
{
    local entity="$1"
    shift
    local ENTITY=("$@")  
    
    local entityvar="${entity,}"
 
    echo "package com.example.$PROJECT_NAME.IService;" > "IService/I${entity}Service.java"
    echo "import com.example.$PROJECT_NAME.DtoEntity.${entity}Dto;" >> "IService/I${entity}Service.java"
    echo "" >> "IService/I${entity}Service.java"
    echo "import java.util.List;" >> "IService/I${entity}Service.java"

    echo "" >> "IService/I${entity}Service.java"
    echo "public interface I${entity}Service {" >> "IService/I${entity}Service.java"

    echo "    ${entity}Dto create${entity}(${entity}Dto ${entityvar}Dto);" >> "IService/I${entity}Service.java"
    echo "" >> "IService/I${entity}Service.java"
    echo "    ${entity}Dto get${entity}ById(Long ${entityvar}Id);" >> "IService/I${entity}Service.java"
    echo "" >> "IService/I${entity}Service.java"
    echo "    List<${entity}Dto> getAll${entity}s();" >> "IService/I${entity}Service.java"
    echo "" >> "IService/I${entity}Service.java"
    echo "    ${entity}Dto update${entity}(Long ${entityvar}Id,${entity}Dto updated${entity}Dto);" >> "IService/I${entity}Service.java"
    echo "" >> "IService/I${entity}Service.java"
    echo "    void delete${entity}(Long ${entityvar}Id);" >> "IService/I${entity}Service.java"
    echo "}" >> "IService/I${entity}Service.java"
}

generate_service()
{
    local entity="$1"
    shift
    local ENTITY=("$@")  
    
    local entityvar="${entity,}"

    echo "package com.example.$PROJECT_NAME.Service;" > "Service/${entity}Service.java"
    echo "import java.util.List;" >> "Service/${entity}Service.java"
    echo "import java.util.stream.Collectors;" >> "Service/${entity}Service.java"
    echo "import org.springframework.stereotype.Service;" >> "Service/${entity}Service.java"

    echo "import com.example.$PROJECT_NAME.DtoEntity.${entity}Dto;" >> "Service/${entity}Service.java"
    echo "import com.example.$PROJECT_NAME.Entity.${entity};" >> "Service/${entity}Service.java"
    echo "import com.example.$PROJECT_NAME.Exception.ResourceNotFoundException;" >> "Service/${entity}Service.java"
    echo "import com.example.$PROJECT_NAME.IService.I${entity}Service;">> "Service/${entity}Service.java"
    echo "import com.example.$PROJECT_NAME.Mapper.${entity}Mapper;" >> "Service/${entity}Service.java"
    echo "import com.example.$PROJECT_NAME.EntityRepository.${entity}Repository;" >> "Service/${entity}Service.java"
    echo "" >> "Service/${entity}Service.java"
    echo "import lombok.AllArgsConstructor;" >> "Service/${entity}Service.java"

    echo "@Service" >> "Service/${entity}Service.java"
    echo "@AllArgsConstructor" >> "Service/${entity}Service.java"
    echo "public class ${entity}Service implements I${entity}Service" >> "Service/${entity}Service.java"
    echo "{" >> "Service/${entity}Service.java"
    echo "" >> "Service/${entity}Service.java"
    echo "    private ${entity}Repository ${entityvar}Repository ;" >> "Service/${entity}Service.java"
    echo "" >> "Service/${entity}Service.java"
    echo "    @Override" >> "Service/${entity}Service.java"
    echo "public ${entity}Dto create${entity}(${entity}Dto ${entityvar}Dto) {" >> "Service/${entity}Service.java"
    echo "        ${entity} ${entityvar} = ${entity}Mapper.mapTo${entity}(${entityvar}Dto);" >> "Service/${entity}Service.java"
    echo "        ${entity} Saved${entityvar} = ${entityvar}Repository.save(${entityvar});" >> "Service/${entity}Service.java"
    echo "return ${entity}Mapper.mapTo${entity}Dto(Saved${entityvar});" >> "Service/${entity}Service.java"
    echo "    }" >> "Service/${entity}Service.java"
    echo "" >> "Service/${entity}Service.java"
    echo "    @Override" >> "Service/${entity}Service.java"
    echo "    public ${entity}Dto get${entity}ById(Long ${entityvar}Id) {" >> "Service/${entity}Service.java"
    echo "        ${entity} ${entityvar}Finded = ${entityvar}Repository.findById(${entityvar}Id)" >> "Service/${entity}Service.java"
    echo "              .orElseThrow(() -> new ResourceNotFoundException(\"${entity} Does not exist !\"));" >> "Service/${entity}Service.java"
    echo "return ${entity}Mapper.mapTo${entity}Dto(${entityvar}Finded);" >> "Service/${entity}Service.java"
    echo "    }" >> "Service/${entity}Service.java"
    echo "" >> "Service/${entity}Service.java"
    echo "    @Override" >> "Service/${entity}Service.java"
    echo "    public List<${entity}Dto> getAll${entity}s() {" >> "Service/${entity}Service.java"
    echo "        List<${entity}> ${entityvar}s = ${entityvar}Repository.findAll();" >> "Service/${entity}Service.java"
    echo "        return ${entityvar}s.stream().map((${entityvar}) -> ${entity}Mapper.mapTo${entity}Dto(${entityvar})).collect(Collectors.toList());" >> "Service/${entity}Service.java"
    echo "    }" >> "Service/${entity}Service.java"
    echo "" >> "Service/${entity}Service.java"
    echo "    @Override" >> "Service/${entity}Service.java"
    echo "    public ${entity}Dto update${entity}(Long ${entityvar}Id, ${entity}Dto updated${entity}Dto) {" >> "Service/${entity}Service.java"
    echo "        ${entity} ${entityvar} = ${entityvar}Repository.findById(${entityvar}Id)" >> "Service/${entity}Service.java"
    echo "        .orElseThrow(() -> new ResourceNotFoundException(\"${entity} Does not exist !\"));" >> "Service/${entity}Service.java"
    echo "// here u ned ot set new fields , like ${entity}.setFIeld(updated${entity}Dto.getField()); for all content" >> "Service/${entity}Service.java"
    first=true
    for((i=0 ; i<${#ENTITY[@]}; i+=3));do
        field_name="${ENTITY[$i]}"
        field_name_with_first_upper="${field_name^}"
        first=true
        if [ "$first" = true ]; then
            echo -n "        ${entityvar}.set${field_name_with_first_upper}(updated${entity}Dto.get${field_name_with_first_upper}());" >> "Service/${entity}Service.java"
        else
            echo -n "        ${entityvar}.set${field_name_with_first_upper}(updated${entity}Dto.get${field_name_with_first_upper}());" >> "Service/${entity}Service.java"
        fi
    done
    echo "" >> "Service/${entity}Service.java"
    echo "        ${entity} Updated${entityvar} = ${entityvar}Repository.save(${entityvar});"  >> "Service/${entity}Service.java"
    echo "        return ${entity}Mapper.mapTo${entity}Dto(Updated${entityvar});" >> "Service/${entity}Service.java"
    echo "    }" >> "Service/${entity}Service.java"
    echo "" >> "Service/${entity}Service.java"
    echo "    @Override" >> "Service/${entity}Service.java"
    echo "    public void delete${entity}(Long ${entityvar}Id) {" >> "Service/${entity}Service.java"
    echo "        ${entity} ${entityvar} = ${entityvar}Repository.findById(${entityvar}Id)" >> "Service/${entity}Service.java"
    echo "              .orElseThrow(() -> new ResourceNotFoundException(\"${entity} Does not exist !\"));" >> "Service/${entity}Service.java"
    echo "        ${entityvar}Repository.deleteById(${entityvar}.getId());" >> "Service/${entity}Service.java"
    echo "    }" >> "Service/${entity}Service.java"
    echo "}" >> "Service/${entity}Service.java"

}
generate_Controller()
{
    local entity="$1"
    shift
    local ENTITY=("$@")  
    
    local entityvar="${entity,}"

    echo "package com.example.$PROJECT_NAME.Controller;" > "Controller/${entity}Controller.java"
    echo "" >> "Controller/${entity}Controller.java"
    echo "import org.springframework.http.HttpStatus;" >> "Controller/${entity}Controller.java"
    echo "import org.springframework.http.ResponseEntity;" >> "Controller/${entity}Controller.java"
    echo "import org.springframework.web.bind.annotation.*;" >> "Controller/${entity}Controller.java"
    echo "" >> "Controller/${entity}Controller.java"
    echo "import java.util.List;" >> "Controller/${entity}Controller.java"
    echo "import com.example.$PROJECT_NAME.DtoEntity.${entity}Dto;" >> "Controller/${entity}Controller.java"
    echo "import com.example.$PROJECT_NAME.Service.${entity}Service;" >> "Controller/${entity}Controller.java"
    echo "" >> "Controller/${entity}Controller.java"
    echo "import lombok.AllArgsConstructor;" >> "Controller/${entity}Controller.java"
    echo "" >> "Controller/${entity}Controller.java"
    echo "@CrossOrigin(\"*\")" >> "Controller/${entity}Controller.java"
    echo "@AllArgsConstructor" >> "Controller/${entity}Controller.java"
    echo "@RestController" >> "Controller/${entity}Controller.java"
    echo "@RequestMapping(\"/api/${entityvar}\")" >> "Controller/${entity}Controller.java"
    echo "public class ${entity}Controller {" >> "Controller/${entity}Controller.java"
    echo "" >> "Controller/${entity}Controller.java"
    echo "private ${entity}Service ${entityvar}Service;" >> "Controller/${entity}Controller.java"
    echo "" >> "Controller/${entity}Controller.java"
    echo "@PostMapping" >> "Controller/${entity}Controller.java"
    echo "public ResponseEntity<${entity}Dto> create${entity}(@RequestBody ${entity}Dto ${entityvar}Dto)" >> "Controller/${entity}Controller.java"
    echo "{" >> "Controller/${entity}Controller.java"
    echo "      ${entity}Dto saved${entity} = ${entityvar}Service.create${entity}(${entityvar}Dto);" >> "Controller/${entity}Controller.java"
    echo "      return new ResponseEntity<>(saved${entity}, HttpStatus.CREATED);" >> "Controller/${entity}Controller.java"    
    echo "}" >> "Controller/${entity}Controller.java"
    echo "" >> "Controller/${entity}Controller.java"
    echo "@GetMapping(\"{id}\")" >> "Controller/${entity}Controller.java"
    echo "public ResponseEntity<${entity}Dto> get${entity}ById(@PathVariable(\"id\") Long ${entityvar}Id)" >> "Controller/${entity}Controller.java"
    echo "{" >> "Controller/${entity}Controller.java"
    echo "      ${entity}Dto ${entityvar}Dto = ${entityvar}Service.get${entity}ById(${entityvar}Id);" >> "Controller/${entity}Controller.java"
    echo "      return ResponseEntity.ok(${entityvar}Dto);" >> "Controller/${entity}Controller.java"
    echo "}" >> "Controller/${entity}Controller.java"
    echo "" >> "Controller/${entity}Controller.java"
    echo "@GetMapping" >> "Controller/${entity}Controller.java"
    echo "public ResponseEntity<List<${entity}Dto>> getAll${entity}()" >> "Controller/${entity}Controller.java"
    echo "{" >> "Controller/${entity}Controller.java"
    echo "      List<${entity}Dto> ${entityvar}s = ${entityvar}Service.getAll${entity}s();" >> "Controller/${entity}Controller.java"
    echo "      return ResponseEntity.ok(${entityvar}s);" >> "Controller/${entity}Controller.java"
    echo "}" >> "Controller/${entity}Controller.java"
    echo "" >> "Controller/${entity}Controller.java"
    echo "@PutMapping(\"{id}\")" >> "Controller/${entity}Controller.java"
    echo "public ResponseEntity<${entity}Dto> update${entity}(@PathVariable(\"id\") Long ${entityvar}Id, @RequestBody ${entity}Dto ${entityvar}Dto)" >> "Controller/${entity}Controller.java"
    echo "{" >> "Controller/${entity}Controller.java"
    echo "      ${entity}Dto ${entityvar} = ${entityvar}Service.update${entity}(${entityvar}Id, ${entityvar}Dto);" >> "Controller/${entity}Controller.java"
    echo "      return ResponseEntity.ok(${entityvar});" >> "Controller/${entity}Controller.java"
    echo "}" >> "Controller/${entity}Controller.java"
    echo "" >> "Controller/${entity}Controller.java"
    echo "@DeleteMapping(\"{id}\")" >> "Controller/${entity}Controller.java"
    echo "public ResponseEntity<String> delete${entity}(@PathVariable(\"id\") Long ${entityvar}Id)" >> "Controller/${entity}Controller.java"
    echo "{" >> "Controller/${entity}Controller.java"
    echo "      ${entityvar}Service.delete${entity}(${entityvar}Id);" >> "Controller/${entity}Controller.java"
    echo "      return ResponseEntity.ok(\"${entity} Deleted Successfully !.\");" >> "Controller/${entity}Controller.java"
    echo "}" >> "Controller/${entity}Controller.java"
    echo "}" >> "Controller/${entity}Controller.java"


}

add_dependencies_to_pom()
{
    cd "$CURRENT_DIR/$PROJECT_NAME"
    local pom_file="pom.xml"

    # Define the dependencies to be added
    local dependencies=(
        '<dependency><groupId>com.h2database</groupId><artifactId>h2</artifactId><version>2.2.224</version><scope>test</scope></dependency>'
        '<dependency><groupId>org.springframework.boot</groupId><artifactId>spring-boot-starter-data-jpa</artifactId><version>3.2.3</version></dependency>'
        '<dependency><groupId>com.mysql</groupId><artifactId>mysql-connector-j</artifactId><version>8.3.0</version></dependency>'
        '<dependency><groupId>org.projectlombok</groupId><artifactId>lombok</artifactId><version>1.18.30</version><scope>provided</scope></dependency>'
    )
    # Check and insert each dependency if it doesn't exist
    for dependency in "${dependencies[@]}"; do
        # Extract artifactId from dependency string
        artifactId=$(echo "$dependency" | grep -oP '(?<=<artifactId>).*(?=</artifactId>)')
        # Check if dependency already exists
        if ! grep -q "<artifactId>$artifactId</artifactId>" "$pom_file"; then
            # Find the line number of the closing </dependencies> tag
            local dependencies_end_line=$(grep -n '</dependencies>' "$pom_file" | cut -d':' -f1)
            # Insert the new dependency just before the closing </dependencies> tag
            sed -i "${dependencies_end_line}i ${dependency}" "$pom_file"
        else
            echo "Dependency $artifactId already exists in pom.xml"
        fi
    done
}

generate_exception_notfound()
{
    echo "package com.example.$PROJECT_NAME.Exception;" > "Exception/ResourceNotFoundException.java"
    echo "import org.springframework.http.HttpStatus;" >> "Exception/ResourceNotFoundException.java"
    echo "import org.springframework.web.bind.annotation.ResponseStatus;" >> "Exception/ResourceNotFoundException.java"
    echo "" >> "Exception/ResourceNotFoundException.java"
    echo "@ResponseStatus(value = HttpStatus.NOT_FOUND)" >> "Exception/ResourceNotFoundException.java"
    echo "public class ResourceNotFoundException extends RuntimeException{" >> "Exception/ResourceNotFoundException.java"
    echo "" >> "Exception/ResourceNotFoundException.java"
    echo "    public ResourceNotFoundException(String message)" >> "Exception/ResourceNotFoundException.java"
    echo "    {" >> "Exception/ResourceNotFoundException.java"
    echo "        super(message);" >> "Exception/ResourceNotFoundException.java"
    echo "    }" >> "Exception/ResourceNotFoundException.java"
    echo "}" >> "Exception/ResourceNotFoundException.java"

}
if [ "$1" = "new" ]; then
    # Vérifier si Spring Boot CLI est installé
    if ! command -v spring &>/dev/null; then
        echo "Spring Boot CLI is not installed"
        exit 1
    fi
    
    if [ -z "$2" ]; then
        echo "Veuillez fournir un nom de projet"
        echo "Usage : springboot new <nom-du-projet>"
        echo "Donner un nom du projet :"
        read PROJECT_NAME
    else
        PROJECT_NAME=$2
    fi
    
    valid_input=false
    while [ "$valid_input" = false ]; do
        echo "Do you prefer to use 1 - Maven , 2 - Gradle ?"
        read choice
        case $choice in
            1)
                ARCHITECTURE=maven
                valid_input=true
            ;;
            2)
                ARCHITECTURE=gradle
                valid_input=true
            ;;
            *)
                echo "Invalid choice. Please enter 1 for Maven or 2 for Gradle."
            ;;
        esac
    done
    
    valid_input=false
    while [ "$valid_input" = false ]; do
        echo "Do you have any dependencies to add except web? (1 - Yes / 2 - No)"
        read choice
        case $choice in
            1)
                echo "Enter dependencies one by one (press Enter without a value to stop)"
                while true; do
                    read dependency
                    if [ -z "$dependency" ]; then
                        break
                    else
                        DEPENDENCIES+=("$dependency")
                    fi
                done
                valid_input=true
            ;;
            2)
                valid_input=true
            ;;
            *)
                echo "Invalid choice. Please enter 1 for yes or 2 for No."
            ;;
        esac
    done
    
    if [ "$ARCHITECTURE" = "maven" ]; then
        
        (IFS=','; spring init -d="${DEPENDENCIES[*]}" --build="$ARCHITECTURE" "$PROJECT_NAME")
        
        elif [ "$ARCHITECTURE" = "gradle" ]; then
        
        (IFS=','; spring init -d="${DEPENDENCIES[*]}" --build="$ARCHITECTURE" --type="$GRADLE_TYPE" "$PROJECT_NAME")
        
    fi
    
elif [ "$1" = "make:model" ]; then
    # taking entity value
    if [ -z "$2" ];then
        echo "Enter the entity name:"
        read entity        
    else

        entity="$2"
    fi
    
    ENTITY=()
    valid_input=false
    while true; do
        echo "New property name (press <return> to stop adding fields):"
        echo ">"
        read field
        if [ -z "$field" ]; then
            break
        fi
        ENTITY+=("$field")
        valid_input=false
        while [ "$valid_input" = false ]; do
            echo "Main Types"
            echo "1 - String"
            echo "2 - Integer"
            echo "3 - Double"
            echo "4 - Date"
            read choice
            case $choice in
                1)
                    ENTITY+=("String")
                    valid_input=true
                ;;
                2)
                    ENTITY+=("int")
                    valid_input=true
                ;;
                3)
                    ENTITY+=("double")
                    valid_input=true
                ;;
                4)
                    ENTITY+=("Date")
                    valid_input=true
                ;;
                *)
                    echo "Invalid choice. Please enter 1-2-3"
                ;;
            esac
        done
        valid_input=false
        while [ "$valid_input" = false ]; do
            echo "Can this field be null in the database (nullable) (1 - yes/ 2 - no):"
            read isNull
            case $isNull in
                1)
                    isNull="true"
                    valid_input=true
                ;;
                2)
                    isNull="false"
                    valid_input=true
                ;;
                *)
                    echo "Invalid choice. Please enter 1 for yes or 2 for No."
                ;;
            esac
        done
        ENTITY+=("$isNull")
    done
    
    cd "$PROJECT_NAME/src/main/java/com/example/$PROJECT_NAME" || exit
    
    # Créer le dossier Entity s'il n'existe pas
    
    if [ ! -d "Entity" ]; then
        mkdir -p "Entity"
        
    fi
    # Créer le dossier EntityRepository s'il n'existe pas
    if [ ! -d "EntityRepository" ]; then
        mkdir -p "EntityRepository"
    fi
    
    # Créer le dossier DtoEntity s'il n'existe pas
    if [ ! -d "DtoEntity" ]; then
        mkdir -p "DtoEntity"
    fi
    # Créer le dossier Mapper s'il n'existe pas
    if [ ! -d "Mapper" ]; then
        mkdir -p "Mapper"
    fi

    # Créer le dossier IService s'il n'existe pas
    if [ ! -d "IService" ]; then
        mkdir -p "IService"
    fi
    # Créer le dossier Service s'il n'existe pas
    if [ ! -d "Service" ]; then
        mkdir -p "Service"
    fi
    # Créer le dossier Controller s'il n'existe pas
    if [ ! -d "Controller" ]; then
        mkdir -p "Controller"
    fi
    # Créer le dossier Exception s'il n'existe pas
    if [ ! -d "Exception" ]; then
        mkdir -p "Exception"
    fi

    # Créer des fichiers pour l'entité et le repository de l'entité
    touch -c "Entity/${entity}.java"
    generate_entity "${entity}" "${ENTITY[@]}"
    touch -c "EntityRepository/${entity}Repository.java"
    generate_entity_repository "${entity}Repository" "$entity"

    # Créer fichier de DtoEntity
    touch -c "DtoEntity/${entity}Dto.java"
    generate_entity_dto "${entity}" "${ENTITY[@]}"

    #Créer fichier Mapper
    touch -c "Mapper/${entity}Mapper.java"
    generate_mapper "${entity}" "${ENTITY[@]}"

    #Creer les fichier services et iservices
    touch -c "IService/I${entity}Service.java"
    touch -c "Service/${entity}Service.java"
    generate_Iservice "${entity}" "${ENTITY[@]}"
    generate_service "${entity}" "${ENTITY[@]}"

    #Creer le controller api 
    touch -c "Controller/${entity}Controller.java"
    generate_Controller "${entity}" "${ENTITY[@]}"

    #Creer le fichier exceptionnotfound
    if [ ! -e "Exception/ResourceNotFoundException.java" ]; then
        touch -c "Exception/ResourceNotFoundException.java"
        generate_exception_notfound
    fi
    

    add_dependencies_to_pom

elif [ "$1" = "run" ]; then
    @echo "Restarting Mysql ..."
    @sudo service mysqld restart
    @echo "Mysql started Successfully"
    @echo "Restarting Apache2 ..."
    @sudo systemctl restart apache2
	@echo "Apache2 started Successfully"
	@echo "you can visit https://localhost/phpmyadmin/index.php"
	@mvn spring-boot:run
	@echo "My application is starting at http://localhost:8080"
fi
