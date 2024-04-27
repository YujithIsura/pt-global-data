public isolated service class PlantData{

    private Plant plant;

    isolated function init(int? plant_id = 0,Plant? plant=null) returns error?{
        
        if(plant !=null){
          self.plant = plant.cloneReadOnly();
          return;
        }

        lock{

            Plant plant_raw;

            plant_raw = check db_client->queryRow(
                `SELECT *
                FROM plants
                WHERE plant_id = ${plant_id};`);
            

            self.plant = plant_raw.cloneReadOnly();

        }
   }

    isolated resource function get plant_id() returns int?|error {
        lock {
            return self.plant.plant_id;
        }
   }

    isolated resource function get common_name() returns string? {
        lock {
                return self.plant.common_name;
        }
    }

    isolated resource function get scientific_name() returns string? {
        lock {
                return self.plant.scientific_name;
        }
    }

    isolated resource function get family() returns string? {
        lock {
                return self.plant.family;
        }
    }
    
    isolated resource function get description() returns string? {
        lock {
                return self.plant.description;
        }
    }

    isolated resource function get care_instructions() returns string? {
        lock {
                return self.plant.care_instructions;
        }
    }

    isolated resource function get photo_url() returns string? {
        lock {
                return self.plant.photo_url;
        }
    }

    isolated resource function get origin() returns string? {
        lock {
                return self.plant.origin;
        }
    }

    isolated resource function get lighting_condition() returns string? {
        lock {
                return self.plant.lighting_condition;
        }
    }

    isolated resource function get substrate() returns string? {
        lock {
                return self.plant.substrate;
        }
    }

    
    isolated resource function get growing_speed() returns string? {
        lock {
                return self.plant.growing_speed;
        }
    }

    isolated resource function get category() returns CategoryData|error? {
        int category_id = 0;
        lock {
            category_id = self.plant.category_id ?: 0;
            if( category_id == 0) {
                return null; // no point in querying if address id is null
            } 
        }
        
        return new CategoryData(category_id);
    }

    isolated resource function get date_added() returns string? {
        lock {
                return self.plant.date_added;
        }
    }

}
