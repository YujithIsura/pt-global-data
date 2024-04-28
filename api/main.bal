import ballerina/graphql;
import ballerina/sql;

service graphql:Service /graphql on new graphql:Listener(4000) {

    isolated resource function get person_by_digital_id(string? id) returns PersonData|error? {

        Person|error? personJwtId = check db_client->queryRow(
            `SELECT *
            FROM person
            WHERE digital_id = ${id};`
        );

        if(personJwtId is Person){
            return new((),0,personJwtId);
        }
        return error("Unable to find person by digital id");
    }

    resource function get plants() returns PlantData[]|error {

        stream<Plant, error?> plants_list;

        lock {
            plants_list = db_client->query(
                `SELECT *
                FROM plants`
            );
        }

        PlantData[] plantDatas = [];

        check from Plant plant in plants_list
            do {
                PlantData|error plantData = new PlantData(0,plant);
                if !(plantData is error) {
                    plantDatas.push(plantData);
                }
            };

        check plants_list.close();
        return plantDatas;

    }

    isolated resource function get plants_by_category(int category_id) returns PlantData[]|error? {

     if(category_id >0 ){

           stream<Plant, error?> plant_ids;
        lock {
            plant_ids = db_client->query(
                `SELECT *
                FROM plants
                WHERE category_id = ${category_id}`
            );
        }

        PlantData[] plants = [];

        check from Plant plant in plant_ids
            do {
                PlantData|error plant_ = new PlantData(plant.plant_id);
                if !(plant_ is error) {
                    plants.push(plant_);
                }
            };
        check plant_ids.close();
        return plants;
        }
    
        return error("Unable to find id");
    }
   
    remote function create_plant(Plant plant) returns PlantData|error? {


        sql:ExecutionResult res = check db_client->execute(
            `INSERT INTO plants (
                common_name,
                scientific_name,
                family,
                description,
                care_instructions,
                photo_url,
                origin,
                lighting_condition,
                substrate,
                growing_speed,
                category_id
            ) VALUES (
                ${plant.common_name},
                ${plant.scientific_name},
                ${plant.family},
                ${plant.description},
                ${plant.care_instructions},
                ${plant.photo_url},
                ${plant.origin},
                ${plant.lighting_condition},
                ${plant.substrate},
                ${plant.growing_speed},
                ${plant.category_id}
            );`
        );

        int|string? insert_id = res.lastInsertId;
        if !(insert_id is int) {
            return error("Unable to insert plant");
        }

        return new (insert_id);
    }
}