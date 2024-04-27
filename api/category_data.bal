public isolated service class CategoryData{

    private Category category;

    isolated function init(int? category_id = 0,Category? category=null) returns error?{
        
        if(category !=null){
          self.category = category.cloneReadOnly();
          return;
        }

        lock{

            Category category_raw;

            category_raw = check db_client->queryRow(
                `SELECT *
                FROM categories
                WHERE category_id = ${category_id};`);
            

            self.category = category_raw.cloneReadOnly();

        }
   }

    isolated resource function get category_id() returns int?|error {
        lock {
            return self.category.category_id;
        }
   }

    isolated resource function get category_name() returns string? {
        lock {
                return self.category.category_name;
        }
   }

    isolated resource function get description() returns string? {
        lock {
                return self.category.description;
        }
   }

}
