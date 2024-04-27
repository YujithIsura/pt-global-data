public type Person record {|
    readonly string? record_type = "person";
    int id?;
    string? full_name;
    string? asgardeo_id;
    string? jwt_sub_id;
    string? jwt_email;
    string? digital_id;
    string? email;
    string? created;
    string? updated;
|};


public type Category record{
    readonly string? record_type = "categories";
    int category_id?;
    string?  category_name;
    string? description;
};

public type Plant record{
    readonly string? record_type = "plants";
    int plant_id?;
    string?  common_name;
    string? scientific_name;
    string? family;
    string? description;
    string? care_instructions;
    string? photo_url;
    string? origin;
    string? lighting_condition;
    string? substrate;
    string? growing_speed;
    int? category_id;
    string? date_added;
};